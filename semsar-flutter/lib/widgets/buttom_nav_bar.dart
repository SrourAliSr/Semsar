import 'package:flutter/material.dart';

class ButtomNavBar extends StatefulWidget {
  final void Function(bool isNext) changePage;
  const ButtomNavBar({super.key, required this.changePage});

  @override
  State<ButtomNavBar> createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(milliseconds: 500),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
      ],
      onDestinationSelected: (value) {
        setState(() {
          index = value;
        });
        if (value == 0) {
          widget.changePage(true);
        }
        if (value == 1) {
          widget.changePage(false);
        }
      },
    );
  }
}
