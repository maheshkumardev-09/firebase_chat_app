import 'package:firebase_chat_app/app/controllers/email_auth_controller.dart';
import 'package:firebase_chat_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  final signinController = Get.put(EmailAuthController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Text('🔥', style: TextStyle(fontSize: 50.sp)),
              SizedBox(width: 10.w),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 8.0.h),
              TextField(
                controller: signinController.nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 8.0.h),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: signinController.emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'password',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 8.0.h),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: signinController.passwordController,
                obscureText: signinController.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      signinController.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      signinController.isPasswordHidden.toggle();
                    },
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                height: 40.h,
                width: 300.w,
                child: ElevatedButton(
                  onPressed: () {
                    signinController.signUp(
                      signinController.emailController.text.trim(),
                      signinController.passwordController.text.trim(),
                      signinController.nameController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.Login);
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
