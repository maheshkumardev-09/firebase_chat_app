class PeopleModel {
  final String id;
  final String name;
  final String image;

  PeopleModel({required this.id, required this.name, required this.image});

  factory PeopleModel.fromMap(Map<String, dynamic> data, String id) {
    return PeopleModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
// class PeopleModel {
//   final String id;
//   final String senderId;
//   final String receiverId;
//   final String status;

//   PeopleModel({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.status,
//   });

//   factory PeopleModel.fromDoc(doc) {
//     return PeopleModel(
//       id: doc.id,
//       senderId: doc['senderId'],
//       receiverId: doc['receiverId'],
//       status: doc['status'],
//     );
//   }
// }
