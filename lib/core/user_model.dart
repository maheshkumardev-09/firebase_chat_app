class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final String lastMessage;
  final String lastMessageTime;

  UserModel({
    required this.uid,
    required this.name,
    this.email = '',
    required this.image,
    this.lastMessage = '',
    required this.lastMessageTime,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
