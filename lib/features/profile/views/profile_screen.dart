import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final profileController = Get.put(ProfileController());

  @override
  // void dispose() {
  //   _newPasswordController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final providers = user.providerData.map((e) => e.providerId).toList();
    final isGoogleUser = providers.contains('google.com');

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User Photo
              CircleAvatar(
                radius: 40,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user.photoURL == null
                    ? Icon(Icons.person, size: 40)
                    : null,
              ),
              SizedBox(height: 12.h),
              Text(
                user.displayName ?? "No Name",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Text(user.email ?? "", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8.h),
              Chip(
                label: Text(isGoogleUser ? "Google Account" : "Email Account"),
                backgroundColor: isGoogleUser
                    ? Colors.red[100]
                    : Colors.blue[100],
              ),
              SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit Profile"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: profileController.goToEditProfile,
                ),
              ),
              SizedBox(height: 8.0.h),
              Card(
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("change password"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: profileController.goToChangePassword,
                ),
              ),
              SizedBox(height: 8.0.h),
              Card(
                child: ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text("Dark Mode"),
                  trailing: Obx(
                    () => Switch(
                      value: profileController.isDarkmode.value,
                      onChanged: (v) => profileController.toggleTheme(),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.0.h),

              // Logout
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () => profileController.logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
