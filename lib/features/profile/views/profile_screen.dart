import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Profile Screen",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
