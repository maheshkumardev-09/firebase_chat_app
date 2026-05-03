import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final List<String> deletedFor;
  final bool isDelivered;
  final bool isSeen;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.deletedFor,
    required this.isDelivered,
    required this.isSeen,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      deletedFor: List<String>.from(data['deletedFor'] ?? []),
      isDelivered: data['isDelivered'] ?? false,
      isSeen: data['isSeen'] ?? false,
    );
  }
}
