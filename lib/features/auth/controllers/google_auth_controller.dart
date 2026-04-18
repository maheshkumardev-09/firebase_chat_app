import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user != null) {
        // 🔥 YAHAN FIRESTORE CODE LAGANA HAI
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "email": user.email,
          "name": user.displayName ?? "No Name",
          "image": user.photoURL,
          "uid": user.uid,
        });

        Get.snackbar("Success", "Google Login Successful");
        Get.offAllNamed(AppRoutes.Home);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut(); // Google ke liye
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    await _auth.signOut(); // sab ke liye
    Get.offAllNamed(AppRoutes.Login);
  }
}
