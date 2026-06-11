import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/chat/controllers/user_controller.dart';
import 'package:firebase_chat_app/features/chat/models/message_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final scrollController = ScrollController();
  final textController = TextEditingController();
  StreamSubscription? _messageSub;
  MessageController(this.receiverId);
  late final String chatId;
  final String receiverId;
  var messageText = "".obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  @override
  void onClose() {
    _messageSub?.cancel();
    scrollController.dispose();
    textController.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    chatId = getChatId(receiverId);
    getMessages();
    markAsDelivered();
    markAsSeen();
    ever(messages, (_) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  var messages = <MessageModel>[].obs;

  String getChatId(String otherUserId) {
    final currentUid = currentUser?.uid ?? '';
    if (currentUid.isEmpty) {
      throw Exception("User not logged in");
    }
    return currentUid.compareTo(otherUserId) < 0
        ? "${currentUid}_$otherUserId"
        : "${otherUserId}_$currentUid";
  }

  Future<void> sendMessage(String receiverId, String text) async {
    if (text.trim().isEmpty) return;

    final uid = currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
          "senderId": uid,
          "receiverId": receiverId,
          "message": text,
          "messageType": "text",
          "timestamp": FieldValue.serverTimestamp(),
          "deletedFor": [],
          "isDelivered": false,
          "isSeen": false,
        });
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    await _firestore.collection("chats").doc(chatId).set({
      "lastMessage": text,
      "lastMessageTime": timeStr,
    }, SetOptions(merge: true));
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().fetchAcceptedUsers();
    }
  }

  Future<void> pickAndSendImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile == null) return;
    await _uploadAndSendMedia(File(pickedFile.path), "image");
  }

  Future<void> pickAndSendVideo() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    await _uploadAndSendMedia(File(pickedFile.path), "video");
  }

  Future<void> _uploadAndSendMedia(File file, String type) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Storage path: chats/chatId/timestamp.jpg
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ext = type == "image" ? "jpg" : "mp4";
      final ref = _storage.ref().child("chats/$chatId/$fileName.$ext");

      // Upload with progress tracking
      final uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        uploadProgress.value = event.bytesTransferred / event.totalBytes;
      });

      await uploadTask;

      // Download URL lao
      final downloadUrl = await ref.getDownloadURL();

      // Firestore mein save karo
      await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add({
            "senderId": uid,
            "receiverId": receiverId,
            "message": downloadUrl, // ✅ URL save hoga
            "messageType": type, // ✅ "image" ya "video"
            "timestamp": FieldValue.serverTimestamp(),
            "deletedFor": [],
            "isDelivered": false,
            "isSeen": false,
          });

      final now = DateTime.now();
      final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      await _firestore.collection("chats").doc(chatId).set({
        "lastMessage": type == "image" ? "📷 Photo" : "🎥 Video",
        "lastMessageTime": timeStr,
      }, SetOptions(merge: true));

      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().fetchAcceptedUsers();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send $type: $e");
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void getMessages() {
    final chatId = getChatId(receiverId);

    _messageSub?.cancel();

    _messageSub = _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((event) {
          messages.value = event.docs
              .map((e) => MessageModel.fromMap(e.data(), e.id))
              .where((msg) => !msg.deletedFor.contains(currentUser!.uid))
              .toList();
        });
  }

  void deleteForEveryone(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  void deleteForMe(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
          "deletedFor": FieldValue.arrayUnion([currentUser!.uid]),
        });
  }

  Future<void> markAsDelivered() async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("receiverId", isEqualTo: uid)
        .where("isDelivered", isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.update({"isDelivered": true});
    }
  }

  Future<void> markAsSeen() async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("receiverId", isEqualTo: uid)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.update({"isSeen": true});
    }
  }
}
