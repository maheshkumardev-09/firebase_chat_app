import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final controller = Get.put(UserController());
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Obx(() {
        if (controller.usersList.isEmpty) {
          return Center(child: Text("No Users Found"));
        }

        return ListView.builder(
          itemCount: controller.usersList.length,
          itemBuilder: (context, index) {
            final user = controller.usersList[index];

            // Apna user hide karo
            if (user.uid == currentUser?.uid) {
              return SizedBox();
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.image.isNotEmpty
                    ? NetworkImage(user.image)
                    : null,
                child: user.image.isEmpty ? Icon(Icons.person) : null,
              ),
              title: Text(user.name),
              subtitle: Text("Last message..."), // baad me dynamic karenge
              trailing: Text("12:30 PM"),
              onTap: () {
                Get.to(
                  MessageScreen(
                    receiverId: user.uid,
                    receiverName: user.name,
                    receiverImage: user.image,
                    // arguments: {
                    //   "name": user.name,
                    //   "uid": user.uid,
                    //   "image": user.image,
                    // },
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
