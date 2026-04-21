import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRequestsScreen extends StatelessWidget {
  const UserRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("friend_requests")
          .where("receiverId", isEqualTo: currentUser!.uid)
          .where("status", isEqualTo: "pending")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data!.docs;

        if (requests.isEmpty) {
          return Center(child: Text("No Requests"));
        }

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];

            return ListTile(
              title: Text("User ID: ${req['senderId']}"),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      // Accept
                      await FirebaseFirestore.instance
                          .collection("friend_requests")
                          .doc(req.id)
                          .update({"status": "accepted"});

                      // Add to contacts
                      await FirebaseFirestore.instance
                          .collection("contacts")
                          .doc(currentUser.uid)
                          .collection("friends")
                          .doc(req['senderId'])
                          .set({"uid": req['senderId']});

                      await FirebaseFirestore.instance
                          .collection("contacts")
                          .doc(req['senderId'])
                          .collection("friends")
                          .doc(currentUser.uid)
                          .set({"uid": currentUser.uid});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("friend_requests")
                          .doc(req.id)
                          .delete();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
