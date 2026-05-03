import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = Get.put(UserController());
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "🔥 FIRECHAT",
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1.h, color: Colors.black),
        ),
      ),
      body: Obx(() {
        final filteredUsers = controller.usersList
            .where((user) => user.uid != currentUser?.uid)
            .toList();
        return Padding(
          padding: EdgeInsets.all(8.0.w),
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.image.isNotEmpty
                        ? NetworkImage(user.image)
                        : null,
                    child: user.image.isEmpty ? Icon(Icons.person) : null,
                  ),
                  title: Text(user.name),
                  subtitle: Text("Last message..."),
                  trailing: Text("12:00 PM"),
                  onTap: () {
                    Get.to(
                      MessageScreen(
                        receiverId: filteredUsers[index].uid,
                        receiverName: filteredUsers[index].name,
                        receiverImage: filteredUsers[index].image,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
