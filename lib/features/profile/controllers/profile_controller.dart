import 'package:firebase_chat_app/core/user_model.dart';
import 'package:firebase_chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final user = Rxn<UserModel>();
  var isDarkmode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void goToEditProfile() {
    Get.toNamed(AppRoutes.EditProfile);
  }

  void loadUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            user.value = UserModel.fromMap(doc.data()!);
          }
        });
  }

  void toggleTheme() {
    isDarkmode.value = !isDarkmode.value;
    Get.changeThemeMode(isDarkmode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void updateProfile(String name) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    loadUser();
  }

  void goToChangePassword() {
    Get.toNamed(AppRoutes.ChangePassword);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.Login);
  }
}
