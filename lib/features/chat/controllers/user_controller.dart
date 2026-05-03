import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/core/user_model.dart';
import 'package:get/get.dart';

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
          Set<String> friendIds = {};
          for (var doc in snapshot.docs) {
            var data = doc.data();

            if (data['senderId'] == currentUser) {
              friendIds.add(data['receiverId']);
            } else if (data['receiverId'] == currentUser) {
              friendIds.add(data['senderId']);
            }
          }

          List<UserModel> tempUsers = [];

          for (String id in friendIds) {
            var userDoc = await _firestore.collection('users').doc(id).get();

            if (userDoc.exists) {
              tempUsers.add(UserModel.fromMap(userDoc.data()!));
            }
          }
          usersList.value = tempUsers;
          final userSnapshot = await _firestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: friendIds.toList())
              .get();

          usersList.value = userSnapshot.docs
              .map((e) => UserModel.fromMap(e.data()))
              .toList();
        });
  }
}
