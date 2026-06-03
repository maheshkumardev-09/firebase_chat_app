import 'package:firebase_chat_app/features/chat/controllers/user_controller.dart';
import 'package:firebase_chat_app/widgets/bottom_navigation_controller.dart';
import 'package:firebase_chat_app/features/chat/views/chat_screen.dart';
import 'package:firebase_chat_app/features/people/views/people_main_screen.dart';
import 'package:firebase_chat_app/features/profile/views/profile_screen.dart';
import 'package:firebase_chat_app/features/calls/views/calls_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});
  final bottomController = Get.put(BottomNavigationController());
  final controller = Get.put(UserController());
  final List<Widget> pages = [
    ChatScreen(),
    PeopleMainScreen(),
    CallsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomController.currentIndex.value,
          onTap: bottomController.updateIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'People'),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: pages[bottomController.currentIndex.value],
      ),
    );
  }
}
