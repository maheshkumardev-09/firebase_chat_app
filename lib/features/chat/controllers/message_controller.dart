import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/models/message_model.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  var messages = <ChatModel>[].obs;

  String getChatId(String otherUserId) {
    final currentUid = currentUser!.uid;

    return currentUid.compareTo(otherUserId) < 0
        ? "${currentUid}_$otherUserId"
        : "${otherUserId}_$currentUid";
  }

  // 🔥 Send Message
  Future<void> sendMessage(String receiverId, String text) async {
    if (text.trim().isEmpty) return;

    final chatId = getChatId(receiverId);

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
          "senderId": currentUser!.uid,
          "receiverId": receiverId,
          "message": text,
          "timestamp": FieldValue.serverTimestamp(),
        });
  }

  // 🔥 Get Messages (Realtime)
  void getMessages(String receiverId) {
    final chatId = getChatId(receiverId);

    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .listen((event) {
          messages.value = event.docs
              .map((e) => ChatModel.fromMap(e.data()))
              .toList();
        });
  }
}
