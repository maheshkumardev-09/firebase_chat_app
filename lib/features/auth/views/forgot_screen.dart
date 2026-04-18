import 'package:firebase_chat_app/features/auth/controllers/email_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatelessWidget {
  final controller = Get.put(EmailAuthController());

  ForgotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.forgotPassword(
                  controller.emailController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text("send reset link", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
