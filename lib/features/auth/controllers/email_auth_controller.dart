import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    if (!GetUtils.isEmail(email.trim())) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": email,
          "uid": user.uid,
        }, SetOptions(merge: true));
      }
      Get.snackbar('Success', 'login successful');
      Get.offAllNamed(AppRoutes.Home);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found with this email");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Incorrect password");
      } else {
        Get.snackbar("Error", e.message ?? "Login failed");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      Get.snackbar('Error', 'Please fiall all fields');
      return;
    }
    if (!GetUtils.isEmail(email.trim())) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }
    if (password.trim().length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": email.trim(),
          "uid": user.uid.trim(),
          "name": name.trim(),
        }, SetOptions(merge: true));
      }

      Get.snackbar("Success", "Account Created");
      Get.offAllNamed(AppRoutes.Home);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email already in use");
      } else if (e.code == 'weak-password') {
        Get.snackbar("Error", "Password too weak");
      } else {
        Get.snackbar("Error", e.message ?? "Signup failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Get.snackbar("Success", "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found with this email");
      } else {
        Get.snackbar("Error", e.message ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
