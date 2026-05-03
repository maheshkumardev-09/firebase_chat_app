import 'package:firebase_chat_app/features/people/controllers/people_controller.dart';
import 'package:firebase_chat_app/features/people/views/user_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'all_users_screen.dart';

class PeopleMainScreen extends StatelessWidget {
  const PeopleMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PeopleController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "People",
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.5.w),
                ),
              ),
              child: TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(text: "All Users"),
                  Tab(text: "Users Requestes"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [AllUsersScreen(), PeopleRequestsScreen()]),
      ),
    );
  }
}
