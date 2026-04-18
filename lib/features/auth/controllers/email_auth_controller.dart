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
  var isPasswordHidden = true.obs;
  Future<void> login(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": email,
          "uid": user.uid,
        });
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
    try {
      // 🔹 Firebase me account create
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      // 🔹 Firestore me user save
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": email,
          "uid": user.uid,
          "name": name,
        });
      }
      SetOptions(merge: true);

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
