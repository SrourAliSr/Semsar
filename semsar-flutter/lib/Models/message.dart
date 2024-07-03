class Message {
  final String chatRoom;

  final String senderId;

  final String reciverId;

  final String message;

  final DateTime sentTime;

  Message({
    required this.chatRoom,
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.sentTime,
  });

  Message.fromMap(Map<String, dynamic> map)
      : chatRoom = map["chatRoom"] as String,
        senderId = map["senderId"] as String,
        reciverId = map["reciverId"] as String,
        message = map["sentMessage"] as String,
        sentTime = DateTime.parse(map["sentTime"]);
}
