import 'package:firebase_chat_app/features/profile/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final user = controller.firebaseUser; // ✅ controller se lo

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => GestureDetector(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundImage: controller.selectedImage.value != null
                      ? FileImage(controller.selectedImage.value!)
                      : (user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null),
                  child:
                      (controller.selectedImage.value == null &&
                          user?.photoURL == null)
                      ? Icon(Icons.person)
                      : null,
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Edit Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              enabled: false,
              initialValue: user?.email ?? '',
              decoration: InputDecoration(
                labelText: "Edit Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: Obx(
                () => controller.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
