import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/people/models/friend_request_model.dart';
import 'package:firebase_chat_app/features/people/models/people_model.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  var users = <PeopleModel>[].obs;
  var friendsIds = <String>[].obs;
  var sentRequests = <String>[].obs;
  var searchText = "".obs;
  var isSearchOpen = false.obs;
  var friendRequests = <FriendRequestModel>[].obs;

  @override
  void onInit() {
    fetchUsers();
    fetchFriends();
    fetchSentRequests();
    fetchFriendRequests();
    super.onInit();
  }

  void fetchUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      users.value = snapshot.docs.map((doc) {
        return PeopleModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  List<PeopleModel> get filteredUsers {
    var filtered = users
        .where(
          (user) =>
              user.id != currentUser &&
              !friendsIds.contains(user.id) &&
              !sentRequests.contains(user.id),
        )
        .toList();

    if (searchText.value.isEmpty) return filtered;

    return filtered.where((user) {
      return user.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) {
      searchText.value = "";
    }
  }

  Future<void> sendFriendRequest(String receiverId) async {
    try {
      await _firestore.collection('friend_requests').add({
        "senderId": currentUser,
        "receiverId": receiverId,
        "status": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Request Sent");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void fetchFriends() {
    _firestore
        .collection("contacts")
        .doc(currentUser)
        .collection("friends")
        .snapshots()
        .listen((snapshot) {
          friendsIds.value = snapshot.docs.map((doc) => doc.id).toList();
        });
  }

  void fetchSentRequests() {
    _firestore
        .collection("friend_requests")
        .where("senderId", isEqualTo: currentUser)
        .snapshots()
        .listen((snapshot) {
          sentRequests.value = snapshot.docs
              .map((doc) => doc['receiverId'] as String)
              .toList();
        });
  }

  void fetchFriendRequests() {
    _firestore
        .collection("friend_requests")
        .where("receiverId", isEqualTo: currentUser)
        .where("status", isEqualTo: "pending")
        .snapshots()
        .listen((snapshot) {
          friendRequests.value = snapshot.docs
              .map((doc) => FriendRequestModel.fromDoc(doc))
              .toList();
        });
  }

  PeopleModel getUserById(String id) {
    return users.firstWhere(
      (u) => u.id == id,
      orElse: () => PeopleModel(id: '', name: 'Unknown', image: ''),
    );
  }
}
