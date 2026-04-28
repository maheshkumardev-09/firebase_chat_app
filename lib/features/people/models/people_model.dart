class PeopleModel {
  final String id;
  final String name;
  final String? image;
  // final String? bio;

  PeopleModel({
    required this.id,
    required this.name,
    this.image,
    // this.bio,
  });

  factory PeopleModel.fromMap(Map<String, dynamic> map, String id) {
    return PeopleModel(
      id: id,
      name: map['name'] ?? '',
      image: map['image'],
      // bio: map['bio'],
    );
  }
}
