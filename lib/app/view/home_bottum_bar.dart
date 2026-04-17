import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/app/controllers/bottum_navigation_controller.dart';
// import 'package:firebase_chat_app/app/controllers/email_auth_controller.dart';
import 'package:firebase_chat_app/app/controllers/google_auth_controller.dart';
import 'package:firebase_chat_app/app/view/app_screens/callls_screen.dart';
import 'package:firebase_chat_app/app/view/app_screens/chat_screen.dart';
import 'package:firebase_chat_app/app/view/app_screens/people_screen.dart';
import 'package:firebase_chat_app/app/view/app_screens/profile_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeBottomBar extends StatelessWidget {
  HomeBottomBar({super.key});
  final controller = Get.put(GoogleAuthController());
  // final emailController = Get.put(EmailAuthController());
  final user = FirebaseAuth.instance.currentUser;
  final bottumcontroller = Get.put(BottomNavController());
  final List<Widget> pages = [
    ChatScreen(),
    PeopleScreen(),
    CallsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottumcontroller.currentIndex.value,
          onTap: bottumcontroller.updateIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'People'),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        body: pages[bottumcontroller.currentIndex.value],
        //  Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        //   child: SizedBox(
        //     width: double.infinity,
        //     height: double.infinity,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         pages[bottumcontroller.currentIndex.value],
        //         Text(
        //           'Welcome, ${user?.displayName ?? "User"}',
        //           style: TextStyle(
        //             fontSize: 24.sp,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         SizedBox(height: 10.h),
        //         // ElevatedButton(
        //         //   onPressed: () {
        //         //     controller.logout();
        //         //   },
        //         //   child: Text("Logout"),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
