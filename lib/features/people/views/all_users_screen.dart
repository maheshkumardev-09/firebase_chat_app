import 'package:firebase_chat_app/features/people/controllers/people_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});
  final peopleController = Get.find<PeopleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          peopleController.isSearchOpen.value
              ? Row(
                  children: [
                    TextField(
                      onChanged: (value) {
                        peopleController.searchText.value = value;
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
        ],
      ),
      body: Obx(() {
        final users = peopleController.filteredUsers;
        if (users.isEmpty) {
          return Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
              title: Text(user.name),
            );
          },
        );
      }),
    );
  }
}
