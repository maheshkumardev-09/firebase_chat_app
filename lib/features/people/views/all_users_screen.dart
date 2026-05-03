import 'package:firebase_chat_app/features/people/controllers/people_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});
  final peopleController = Get.put(PeopleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(
            () => peopleController.isSearchOpen.value
                ? Row(
                    children: [
                      TextField(
                        onChanged: (value) {
                          peopleController.searchText.value = value;
                        },
                        autofocus: true,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          peopleController.toggleSearch();
                        },
                      ),
                    ],
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      peopleController.toggleSearch();
                    },
                  ),
          ),
        ],
      ),
      body: Obx(() {
        final users = peopleController.filteredUsers;
        if (peopleController.users.isEmpty) {
          return Center(child: Text("No Users Found"));
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundImage:
                            (user.image != null && user.image!.isNotEmpty)
                            ? NetworkImage(user.image!)
                            : null,
                        child: (user.image == null || user.image!.isEmpty)
                            ? Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: Builder(
                        builder: (_) {
                          final isSent = peopleController.sentRequests.contains(
                            user.id,
                          );
                          return ElevatedButton(
                            onPressed: isSent
                                ? null // disable button
                                : () {
                                    peopleController.sendFriendRequest(user.id);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSent
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                            child: Text(isSent ? "Sent" : "Send Request"),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
