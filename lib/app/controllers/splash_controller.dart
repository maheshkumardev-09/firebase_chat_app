import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 2));

    if (FirebaseAuth.instance.currentUser != null) {
      // ✅ Already login hai
      Get.offAllNamed(AppRoutes.Home);
    } else {
      // ❌ Login nahi hai
      Get.offAllNamed(AppRoutes.Login);
    }
  }
}
