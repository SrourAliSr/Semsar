import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/hub_connection.dart';
import 'package:semsar/constants/user_settings.dart';
import 'package:semsar/services/curd/crud_db.dart';
import 'package:semsar/services/curd/messages_db.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoom;
  final String receiverName;
  final String receiverId;
  final bool? isNewChat;

  const ChatRoom({
    super.key,
    required this.chatRoom,
    required this.receiverName,
    required this.receiverId,
    this.isNewChat,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController controller = TextEditingController();
  SemsarDb db = SemsarDb();

  @override
  void initState() {
    _addGoup();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (widget.isNewChat == true) {
      await db.addChatRoom(
        userId: UserSettings.user!.userId,
        reciverId: widget.receiverId,
        reciverName: widget.receiverName,
      );
    }

    if (hubConnection!.connectionId == null) {
      log("connection reconnectiong");
      await hubConnection?.start()?.then(
            (value) => hubConnection!.invoke(
              'SendMessage',
              args: <Object>[
                {
                  "ChatRoom": widget.chatRoom,
                  "SenderId": UserSettings.user!.userId,
                  "SenderName": UserSettings.user!.userName,
                  "SentMessage": message,
                  "ReciverId": widget.receiverId,
                  "SentTime": DateTime.now().toIso8601String(),
                },
              ],
            ),
          );
    } else {
      hubConnection!.invoke(
        'SendMessage',
        args: <Object>[
          {
            "ChatRoom": widget.chatRoom,
            "SenderId": UserSettings.user!.userId,
            "SenderName": UserSettings.user!.userName,
            "SentMessage": message,
            "ReciverId": widget.receiverId,
            "SentTime": DateTime.now().toIso8601String(),
          },
        ],
      );
    }
  }

  void _addGoup() {
    hubConnection!.invoke(
      'AddGroup',
      args: <Object>[
        {
          "UserId": UserSettings.user!.userId,
          "Username": UserSettings.user!.userName,
          "ChatRoom": widget.chatRoom,
        }
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<Iterable<MessagesDatabase>>(
                stream: db.getChat(chatRoom: widget.chatRoom),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading messages'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _MessageBubble(
                          messages.elementAt((messages.length - 1) - index));
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) {
                        _sendMessage(value);
                        controller.clear();
                      },
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage(controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessagesDatabase message;
  const _MessageBubble(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: (message.senderId == UserSettings.user!.userId)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message());
  }

  Widget _message() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        crossAxisAlignment: (message.senderId == UserSettings.user!.userId)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: (message.senderId == UserSettings.user!.userId)
                  ? AppColors.cinderella
                  : AppColors.orange,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(9),
                bottomLeft: (message.senderId == UserSettings.user!.userId)
                    ? const Radius.circular(9)
                    : const Radius.circular(0),
                bottomRight: (message.senderId == UserSettings.user!.userId)
                    ? const Radius.circular(0)
                    : const Radius.circular(9),
                topRight: const Radius.circular(9),
              ),
            ),
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              ' ${message.message}',
              style: const TextStyle(fontSize: 16),
              maxLines: null,
            ),
          ),
          Text(
            '${message.sentTime.hour % 12 == 0 ? 12 : message.sentTime.hour % 12}:${message.sentTime.minute.toString().padLeft(2, '0')} ${message.sentTime.hour >= 12 ? 'PM' : 'AM'}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
