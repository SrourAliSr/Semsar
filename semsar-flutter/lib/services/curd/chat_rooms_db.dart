class ChatRoomsDatabase {
  final String userId;
  final String reciverId;
  final String reciverName;
  final String chatRoom;

  ChatRoomsDatabase({
    required this.userId,
    required this.reciverId,
    required this.reciverName,
    required this.chatRoom,
  });

  ChatRoomsDatabase.fromRow(Map<String, Object?> map)
      : userId = map["userId"] as String,
        reciverId = map["receiverId"] as String,
        reciverName = map["receiverName"] as String,
        chatRoom = map["chatRoomId"] as String;

  @override
  String toString() =>
      'user id is : $userId , reciverId id is : $reciverId, chatroom : $chatRoom';

  @override
  bool operator ==(covariant ChatRoomsDatabase other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
