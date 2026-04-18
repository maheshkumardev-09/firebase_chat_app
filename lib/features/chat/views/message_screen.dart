import 'package:firebase_chat_app/features/chat/controllers/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  MessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    // required Map<String, dynamic> arguments,
  });

  final controller = Get.put(MessageController());
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.getMessages(receiverId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(receiverImage)),
            SizedBox(width: 10),
            Text(receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🔥 Messages List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUser!.uid;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg.message,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // 🔥 Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(hintText: "Type message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(receiverId, textController.text);
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
