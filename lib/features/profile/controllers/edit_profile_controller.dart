import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/features/profile/controllers/profile_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var selectedImage = Rxn<File>();
  var isLoading = false.obs;
  User? get firebaseUser => FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<String?> uploadImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || selectedImage.value == null) return null;

      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/${user.uid}.jpg',
      );

      await ref.putFile(selectedImage.value!);

      final url = await ref.getDownloadURL();
      // print("Image URL: $url");

      return url;
    } catch (e) {
      // print("Upload Error: $e");
      return null;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? imageUrl;

      if (selectedImage.value != null) {
        imageUrl = await uploadImage();
      }
      final newName = nameController.text.trim();
      final newEmail = emailController.text.trim();
      await user.updateDisplayName(newName);

      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        Get.snackbar("Info", "You already use this email");
        return;
      }

      if (imageUrl != null) {
        await user.updatePhotoURL(imageUrl);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': newName,
        'email': newEmail,
        'image': imageUrl ?? user.photoURL ?? '',
      }, SetOptions(merge: true));

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUser();
      }

      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
