import 'package:firebase_chat_app/features/profile/controllers/profile_controller.dart';
import 'package:firebase_chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(height: 1.h, color: Colors.black),
        ),
      ),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage: user.image.isNotEmpty
                      ? NetworkImage(user.image)
                      : null,
                  child: user.image.isEmpty ? Icon(Icons.person) : null,
                ),

                SizedBox(height: 20.h),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(user.email, style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 30.h),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Edit Profile"),
                    onTap: () {
                      Get.toNamed(AppRoutes.EditProfile);
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                SizedBox(height: 20.h),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ),
                SizedBox(height: 20.h),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text("Dark Mode"),
                    trailing: Obx(
                      () => Switch(
                        value: controller.isDarkmode.value,
                        onChanged: (value) {
                          controller.toggleTheme();
                        },
                        activeColor: Colors.orange,
                        inactiveThumbColor: Colors.grey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
                SizedBox(
                  height: 40.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
