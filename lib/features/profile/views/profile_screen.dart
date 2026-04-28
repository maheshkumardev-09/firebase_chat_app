import 'package:firebase_chat_app/features/auth/controllers/google_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final logOutController = Get.put(GoogleAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Profile Screen",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          Center(
            child: SizedBox(
              height: 40.h,
              width: 300.w,
              child: ElevatedButton(
                onPressed: () {
                  logOutController.logout();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(
                  'LogOut',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
