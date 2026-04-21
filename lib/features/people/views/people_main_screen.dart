import 'package:firebase_chat_app/features/people/views/user_requests_screen.dart';
import 'package:flutter/material.dart';
import 'all_users_screen.dart';

class PeopleMainScreen extends StatelessWidget {
  const PeopleMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("People"),
          bottom: TabBar(
            tabs: [
              Tab(text: "All Users"),
              Tab(text: "Users Requestes"),
            ],
          ),
        ),
        body: TabBarView(children: [AllUsersScreen(), UserRequestsScreen()]),
      ),
    );
  }
}
