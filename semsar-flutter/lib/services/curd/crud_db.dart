import 'dart:async';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:semsar/Models/message.dart';
import 'package:semsar/Models/user.dart';
import 'package:semsar/constants/database_tables.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/curd/chat_rooms_db.dart';
import 'package:semsar/services/curd/messages_db.dart';
import 'package:semsar/services/curd/users_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

//Exceptions classes
class DataBaseAlreadyOpenException implements Exception {}

class UnableToGetDocmunetsDirectory implements Exception {}

class DataBaseIsNotOpen implements Exception {}

class CouldNotDeleteUser implements Exception {}

class UserAlreadyExists implements Exception {}

class CouldNotFoundUser implements Exception {}

class CouldNotDeleteNote implements Exception {}

class CouldNotFoundNotes implements Exception {}

class DidNotUpdateTheNote implements Exception {}

class ChatRoomIsNotCreated implements Exception {}

class UserShouldBeSetBeforeReadingAllNotes implements Exception {}

class SemsarDb {
  Database? _db;
  final List<MessagesDatabase> _messages = [];

  static final SemsarDb _shared = SemsarDb._sharedInstace();

  factory SemsarDb() => _shared;

  late final StreamController<Iterable<MessagesDatabase>> _chatStreamController;
  SemsarDb._sharedInstace() {
    _chatStreamController =
        StreamController<Iterable<MessagesDatabase>>.broadcast(
      onListen: () {
        _chatStreamController.sink.add(_messages);
      },
    );
    _loadInitialMessages();
  }

  Future<void> delete() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await db.delete(chatRoomsTable);

    await db.delete(messagesTable);
  }

  Future<void> _loadInitialMessages() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final chat = await db.query(
      messagesTable,
      orderBy: 'sentTime',
    );
    final result = chat
        .map(
          (noteRow) => MessagesDatabase.fromRow(noteRow),
        )
        .toList();
    _messages.addAll(result);
    _chatStreamController.add(_messages);
  }

  Future<DataBaseUser> getOrCreateUser({
    required User user,
  }) async {
    try {
      final fetchedUser = await getUser(email: user.email);

      return fetchedUser;
    } on Exception catch (_) {
      return await createUser(user: user);
    }
  }

  void _loadInitialData(String chatRoom) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final chat = await db.query(
      messagesTable,
      where: 'chatRoomId = ?',
      whereArgs: [chatRoom],
      orderBy: 'sentTime',
    );
    final result = chat
        .map(
          (noteRow) => MessagesDatabase.fromRow(noteRow),
        )
        .toList();
    _messages.clear();
    _messages.addAll(result);
    _chatStreamController.add(_messages);
  }

  Stream<Iterable<MessagesDatabase>> getChat({
    required String chatRoom,
  }) async* {
    _loadInitialData(chatRoom);
    yield* _chatStreamController.stream;
  }

  Future<Iterable<ChatRoomsDatabase>> getChatRooms() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final userId = UserSettings.user!.userId;

    final chatRooms = await db
        .query(chatRoomsTable, where: 'userId = ?', whereArgs: [userId]);

    final result = chatRooms.map(
      (noteRow) => ChatRoomsDatabase.fromRow(
        noteRow,
      ),
    );

    return result;
  }

  // Future<void> addReceviverNameColumn() async {
  //   final db = _getDatabaseOrThrow();
  //   final test = await db.rawQuery('''
  //       ALTER TABLE chatRooms ADD COLUMN receiverName TEXT
  //     ''');
  //   if (test.isNotEmpty) {
  //     log('Sucessssssssssssssssssssssssssss');
  //   }
  // }

  Future<void> deleteChatRoom(String chatId) async {
    final db = _getDatabaseOrThrow();

    final query = await db
        .delete(chatRoomsTable, where: 'chatRoomId = ?', whereArgs: [chatId]);

    log(query.toString());
  }

  Future<void> addChatRoom({
    required String userId,
    required String reciverId,
    required String reciverName,
  }) async {
    List<String> sortedIds = [userId, reciverId];

    sortedIds.sort();

    final String chatRoomId = sortedIds.join("_");

    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    try {
      final chatRoom = await db.query(
        chatRoomsTable,
        where: 'chatRoomId = ?',
        limit: 1,
        whereArgs: [chatRoomId],
      );

      if (chatRoom.isEmpty) {
        throw ChatRoomIsNotCreated();
      }
    } on ChatRoomIsNotCreated catch (_) {
      await db.insert(
        chatRoomsTable,
        {
          "userId": userId,
          "receiverId": reciverId,
          "receiverName": reciverName,
          "chatRoomId": chatRoomId,
        },
      );
    }
  }

  Future<MessagesDatabase> saveMessage({required Message message}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    try {
      final id = await db.insert(
        messagesTable,
        {
          "senderId": message.senderId,
          "receiverId": message.reciverId,
          "message": message.message,
          "chatRoomId": message.chatRoom,
          "sentTime": message.sentTime.millisecondsSinceEpoch,
        },
      );
      final newMessage = MessagesDatabase(
        id: id,
        senderId: message.senderId,
        message: message.message,
        reciverId: message.reciverId,
        chatRoom: message.chatRoom,
        sentTime: message.sentTime,
      );
      _messages.add(newMessage);
      _chatStreamController.add(_messages);
      return newMessage;
    } catch (e) {
      log('saving message error happened : $e.$toString()');
      rethrow;
    }
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    try {} on DataBaseIsNotOpen {
      await _ensureDbIsOpen();
    }
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFoundUser();
    } else {
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<DataBaseUser> createUser({required User user}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: ' email = ?',
      whereArgs: [user.email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    } else {
      await db.insert(
        userTable,
        {
          "userId": user.userId,
          "email": user.email.toLowerCase(),
          "username": user.userName,
          "phone_number": user.phoneNumber,
        },
      );

      return DataBaseUser(
        userId: user.userId,
        email: user.email,
        userName: user.userName,
        phoneNumber: user.phoneNumber,
      );
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  void opening() async {
    try {} on DataBaseIsNotOpen {
      await _ensureDbIsOpen();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpen();
    }
    return db;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    } else {
      try {
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);

        _db = db;

        //created a constant user table with the constants down below
        await db.execute(createUsersTable);

        //created a constant chat rooms table with the constants down below
        await db.execute(createChatRoomsTable);

        //created a constant chat rooms table with the constants down below
        await db.execute(createMessagesTable);
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocmunetsDirectory();
      }
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DataBaseAlreadyOpenException {
      return;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}
