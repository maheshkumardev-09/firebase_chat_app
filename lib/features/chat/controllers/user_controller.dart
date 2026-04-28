import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  var usersList = <UserModel>[].obs;

  @override
  void onInit() {
    fetchAcceptedUsers();
    super.onInit();
  }

  void fetchAcceptedUsers() {
    _firestore
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((snapshot) async {
          List<String> friendIds = [];

          for (var doc in snapshot.docs) {
            var data = doc.data();

            // 🔹 agar current user sender hai
            if (data['senderId'] == currentUser) {
              friendIds.add(data['receiverId']);
            }
            // 🔹 agar current user receiver hai
            else if (data['receiverId'] == currentUser) {
              friendIds.add(data['senderId']);
            }
          }

          // 🔥 ab users collection se detail lao
          List<UserModel> tempUsers = [];

          for (String id in friendIds) {
            var userDoc = await _firestore.collection('users').doc(id).get();

            if (userDoc.exists) {
              tempUsers.add(UserModel.fromMap(userDoc.data()!));
            }
          }
          usersList.value = tempUsers;
        });
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_chat_app/features/chat/models/user_model.dart';
// import 'package:get/get.dart';

// class UserController extends GetxController {
//   var usersList = <UserModel>[].obs;

//   @override
//   void onInit() {
//     fetchUsers();
//     super.onInit();
//   }

//   void fetchUsers() {
//     FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
//       usersList.value = event.docs
//           .map((doc) => UserModel.fromMap(doc.data()))
//           .toList();
//     });
//   }
// }
