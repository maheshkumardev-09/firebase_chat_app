import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChangePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  User? get user => FirebaseAuth.instance.currentUser;

  bool get isGoogleUser =>
      user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
  bool get hasPassword =>
      user?.providerData.any((p) => p.providerId == 'password') ?? false;

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _validate() {
    final pass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return false;
    }
    if (pass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long");
      return false;
    }
    if (pass != confirm) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    }
    return true;
  }

  Future<void> handleChangePassword() async {
    if (!_validate()) return;

    final pass = newPasswordController.text.trim();

    if (isGoogleUser && !hasPassword) {
      await _setPasswordForGoogleUser(pass);
    } else {
      await _changePasswordViaGoogle(pass);
    }
  }

  Future<void> _setPasswordForGoogleUser(String newPassword) async {
    try {
      isLoading.value = true;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: newPassword,
      );
      await user!.linkWithCredential(credential);
      await user!.reload();
      Get.snackbar("Success", "Password has been set successfully!");
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _changePasswordViaGoogle(String newPassword) async {
    try {
      isLoading.value = true;

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPassword);

      Get.snackbar("Success", "Password updated successfully!");
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed");
    } finally {
      isLoading.value = false;
    }
  }
}
