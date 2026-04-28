import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/people/controllers/people_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PeopleRequestsScreen extends StatelessWidget {
  PeopleRequestsScreen({super.key});

  final peopleController = Get.find<PeopleController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final requests = peopleController.friendRequests;

      if (requests.isEmpty) {
        return Center(child: Text("No Requests"));
      }

      return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];

          final user = peopleController.getUserById(request.senderId);

          final image = user.image ?? "";

          return ListTile(
            leading: CircleAvatar(
              radius: 25.r,
              backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
              child: image.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(user.name),
          );
        },
      );
    });
  }
}
