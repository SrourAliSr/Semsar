class MessagesDatabase {
  final int id;
  final String senderId;
  final String reciverId;
  final String message;
  final String chatRoom;
  final DateTime sentTime;

  MessagesDatabase({
    required this.id,
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.chatRoom,
    required this.sentTime,
  });

  MessagesDatabase.fromRow(Map<String, Object?> map)
      : id = map["id"] as int,
        senderId = map["senderId"] as String,
        reciverId = map["receiverId"] as String,
        message = map["message"] as String,
        chatRoom = map["chatRoomId"] as String,
        sentTime = DateTime.fromMillisecondsSinceEpoch(map["sentTime"] as int);

  @override
  String toString() =>
      'id is : $id , sender id is : $senderId, reciverId : $reciverId';

  @override
  bool operator ==(covariant MessagesDatabase other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
