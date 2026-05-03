import 'package:firebase_chat_app/core/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  final user = Rxn<UserModel>();
  var isDarkmode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      user.value = UserModel(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'No Name',
        email: firebaseUser.email ?? 'No Email',
        image: firebaseUser.photoURL ?? '',
      );
    }
  }

  void toggleTheme() {
    isDarkmode.value = !isDarkmode.value;
    Get.changeThemeMode(isDarkmode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
