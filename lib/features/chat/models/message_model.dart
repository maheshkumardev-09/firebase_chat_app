class ChatModel {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}
