import 'package:firebase_chat_app/features/auth/controllers/email_auth_controller.dart';
import 'package:firebase_chat_app/features/auth/controllers/google_auth_controller.dart';
import 'package:firebase_chat_app/routes/app_routes.dart';
import 'package:firebase_chat_app/features/auth/views/forgot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final googleAuthController = Get.put(GoogleAuthController());
  final logincontroller = Get.put(EmailAuthController());
  final bool passwordVisible = false;

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Text(
                'Log in to Fire Chat',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Text(
                'Welcome back! Sign in with your social accont or phone number to continue us.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/logo/Facebook.png',
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                  // SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      googleAuthController.signInWithGoogle();
                    },
                    child: Image.asset(
                      'assets/logo/Google.png',
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  SizedBox(width: 10.w),
                  Text(
                    'or',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'your email',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 8.0.h),
              TextFormField(
                controller: logincontroller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  errorText: null,
                ),
              ),
              SizedBox(height: 12.h),
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
              Obx(
                () => TextField(
                  controller: logincontroller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: logincontroller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        logincontroller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        logincontroller.isPasswordHidden.toggle();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Obx(
                () => SizedBox(
                  height: 40.h,
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: logincontroller.isLoading.value
                        ? null
                        : () async {
                            await logincontroller.login(
                              logincontroller.emailController.text.trim(),
                              logincontroller.passwordController.text.trim(),
                            );
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  Get.to(() => ForgotScreen());
                },
                child: Text(
                  'forgot password?',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'i don\'t have an account?',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.SignUp);
                    },
                    child: Text(
                      "Create Account",
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
