class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;

  UserModel({
    required this.uid,
    required this.name,
    this.email = '',
    required this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
