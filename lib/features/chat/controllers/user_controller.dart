import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/features/chat/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var usersList = <UserModel>[].obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      usersList.value = event.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }
}
