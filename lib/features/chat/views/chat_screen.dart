import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../controllers/user_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = Get.put(UserController());
  // final controller = Get.find<UserController>();
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
        final users = controller.usersList;

        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
        return Padding(
          padding: EdgeInsets.all(8.0.w),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: user.image.isNotEmpty
                        ? NetworkImage(user.image)
                        : null,
                    child: user.image.isEmpty ? Icon(Icons.person) : null,
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    user.lastMessage.isEmpty
                        ? "No messagesYet"
                        : user.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing:
                      user.lastMessage.isEmpty || user.lastMessageTime.isEmpty
                      ? null
                      : Text(
                          intl.DateFormat(
                            'hh:mm a',
                          ).format(DateTime.parse(user.lastMessageTime)),
                        ),
                  onTap: () {
                    Get.to(
                      MessageScreen(
                        receiverId: user.uid,
                        receiverName: user.name,
                        receiverImage: user.image,
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
