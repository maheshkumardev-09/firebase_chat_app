import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/views/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:get/get.dart';
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
        } else if (users.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No friends yet. Add some friends to start chatting!\n Go to people screen and send friend request",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 50.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 40.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('/people');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        "Find Friends",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
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
                    trailing: user.lastMessageTime.isEmpty
                        ? null
                        : Text(user.lastMessageTime),
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
        }
      }),
    );
  }
}
