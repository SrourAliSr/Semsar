import 'package:flutter/material.dart';
import 'package:semsar/constants/app_colors.dart';
import 'package:semsar/constants/route_names.dart';
import 'package:semsar/services/curd/chat_rooms_db.dart';
import 'package:semsar/services/curd/crud_db.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({
    super.key,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  SemsarDb db = SemsarDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await db.delete();
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!.isNotEmpty) {
            final Iterable<ChatRoomsDatabase> chatRooms = snapshot.data!;

            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      chatRoomRotes,
                      arguments: {
                        "chatRoom": chatRooms.elementAt(index).chatRoom,
                        "receiverName": chatRooms.elementAt(index).reciverName,
                        "receiverId": chatRooms.elementAt(index).reciverId,
                      },
                    );
                  },
                  child: _ContactCard(
                    contactName: chatRooms.elementAt(index).reciverName,
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chats yet!'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String contactName;
  const _ContactCard({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.cinderella,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.3,
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.orange,
            child: Icon(
              Icons.person,
              color: AppColors.darkBrown,
              size: 40,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            contactName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
