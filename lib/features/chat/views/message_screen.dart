import 'package:firebase_chat_app/features/chat/controllers/message_controller.dart';
import 'package:firebase_chat_app/features/chat/models/message_model.dart';
import 'package:firebase_chat_app/features/chat/views/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const MessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController(receiverId), tag: receiverId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: receiverImage.isNotEmpty
                  ? NetworkImage(receiverImage)
                  : null,
              child: receiverImage.isEmpty ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                receiverName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Icon(Icons.video_camera_front_outlined),
          SizedBox(width: 10.w),
          Icon(Icons.call_outlined),
          SizedBox(width: 30.w),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            // if (controller.isUploading.value) return SizedBox.shrink();
            if (!controller.isUploading.value) return SizedBox.shrink();
            return Column(
              children: [
                LinearProgressIndicator(value: controller.uploadProgress.value),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    "Uploading... ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
              ],
            );
          }),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                controller: controller.scrollController,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUser!.uid;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: () {
                        final chatId = controller.getChatId(receiverId);

                        Get.bottomSheet(
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Wrap(
                              children: [
                                if (isMe)
                                  ListTile(
                                    title: Text("Delete for Everyone"),
                                    onTap: () {
                                      controller.deleteForEveryone(
                                        chatId,
                                        msg.id,
                                      );
                                      Get.back();
                                    },
                                  ),
                                ListTile(
                                  title: Text("Delete for Me"),
                                  onTap: () {
                                    controller.deleteForMe(chatId, msg.id);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },

                      // 🔥 Message bubble
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 10.w,
                        ),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            _buildMessageContent(msg, isMe),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                if (isMe) ...[
                                  SizedBox(width: 4.w),
                                  Icon(
                                    msg.isSeen
                                        ? Icons.done_all
                                        : msg.isDelivered
                                        ? Icons.done_all
                                        : Icons.check,
                                    size: 16,
                                    color: msg.isSeen
                                        ? Colors.blue
                                        : msg.isDelivered
                                        ? Colors.grey
                                        : Colors.white70,
                                  ),
                                ],
                              ],
                            ),
                            // SizedBox(height: 5.h),
                            // Text(
                            //   "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                            //   style: TextStyle(
                            //     color: isMe ? Colors.white70 : Colors.black54,
                            //     fontSize: 12.sp,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    onChanged: (value) {
                      controller.messageText.value = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.emoji_emotions_outlined),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.camera_alt_outlined),
                            onPressed: () => controller.pickAndSendImage(),
                          ),
                          SizedBox(width: 8.0.w),
                          IconButton(
                            icon: Icon(Icons.attach_file_outlined),
                            onPressed: () => controller.pickAndSendVideo(),
                          ),
                          SizedBox(width: 8.0.w),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0.w),
                Obx(
                  () => FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: controller.messageText.value.trim().isEmpty
                        ? null
                        : () {
                            controller.sendMessage(
                              receiverId,
                              controller.messageText.value,
                            );
                            controller.textController.clear();
                            controller.messageText.value = "";
                          },
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(msg, bool isMe) {
    switch (msg.messageType) {
      case MessageType.image:
        return GestureDetector(
          onTap: () {
            Get.dialog(
              Dialog(
                child: InteractiveViewer(
                  child: Image.network(msg.message, fit: BoxFit.contain),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              msg.message,
              width: 200.w,
              height: 200.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 200.w,
                  height: 200.h,
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        );
      case MessageType.video:
        return VideoMessageWidget(url: msg.message);
      default:
        return Text(
          msg.message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        );
    }
  }
}
