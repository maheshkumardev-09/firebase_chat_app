class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  factory FriendRequestModel.fromDoc(doc) {
    return FriendRequestModel(
      id: doc.id,
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      status: doc['status'],
    );
  }
}
