import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/features/people/models/friend_request_model.dart';
import 'package:firebase_chat_app/features/people/models/people_model.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  // 🔥 State
  var users = <PeopleModel>[].obs;
  var friendsIds = <String>[].obs;
  var sentRequests = <String>[].obs;
  var friendRequests = <FriendRequestModel>[].obs;

  var searchText = "".obs;
  var isSearchOpen = false.obs;

  // 🔥 Subscriptions (memory safe)
  StreamSubscription? _usersSub;
  StreamSubscription? _friendsSub;
  StreamSubscription? _sentSub;
  StreamSubscription? _requestsSub;

  // 🔥 Fast lookup map
  Map<String, PeopleModel> usersMap = {};

  @override
  void onInit() {
    fetchUsers();
    fetchFriends();
    fetchSentRequests();
    fetchFriendRequests();
    super.onInit();
  }

  @override
  void onClose() {
    _usersSub?.cancel();
    _friendsSub?.cancel();
    _sentSub?.cancel();
    _requestsSub?.cancel();
    super.onClose();
  }

  // ================= USERS =================

  void fetchUsers() {
    _usersSub = _firestore.collection('users').snapshots().listen((snapshot) {
      final list = snapshot.docs
          .map((doc) => PeopleModel.fromMap(doc.data(), doc.id))
          .toList();

      users.value = list;

      // 🔥 create map for fast lookup
      usersMap = {for (var u in list) u.id: u};
    });
  }

  // ================= FILTER =================

  List<PeopleModel> get filteredUsers {
    final friendsSet = friendsIds.toSet();
    final sentSet = sentRequests.toSet();

    var filtered = users.where((user) {
      return user.id != currentUser &&
          !friendsSet.contains(user.id) &&
          !sentSet.contains(user.id);
    }).toList();

    if (searchText.value.isEmpty) return filtered;

    return filtered.where((user) {
      return user.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) searchText.value = "";
  }

  // ================= FRIEND REQUEST =================

  Future<void> sendFriendRequest(String receiverId) async {
    try {
      // 🔴 Check duplicate request
      final existing = await _firestore
          .collection('friend_requests')
          .where("senderId", isEqualTo: currentUser)
          .where("receiverId", isEqualTo: receiverId)
          .get();

      if (existing.docs.isNotEmpty) {
        Get.snackbar("Info", "Request already sent");
        return;
      }

      final reverse = await _firestore
          .collection('friend_requests')
          .where("senderId", isEqualTo: receiverId)
          .where("receiverId", isEqualTo: currentUser)
          .get();

      if (reverse.docs.isNotEmpty) {
        await reverse.docs.first.reference.update({"status": "accepted"});

        await addToContacts(receiverId);

        Get.snackbar("Success", "Friend Added");
        return;
      }

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

  Future<void> acceptRequest(FriendRequestModel request) async {
    await _firestore.collection("friend_requests").doc(request.id).update({
      "status": "accepted",
    });

    await addToContacts(request.senderId);

    Get.snackbar("Success", "Request Accepted");
  }

  Future<void> deleteRequest(String requestId) async {
    await _firestore.collection("friend_requests").doc(requestId).delete();

    Get.snackbar("Removed", "Request Deleted");
  }

  Future<void> addToContacts(String otherUserId) async {
    await _firestore
        .collection("contacts")
        .doc(currentUser)
        .collection("friends")
        .doc(otherUserId)
        .set({"uid": otherUserId});

    await _firestore
        .collection("contacts")
        .doc(otherUserId)
        .collection("friends")
        .doc(currentUser)
        .set({"uid": currentUser});
  }

  void fetchFriends() {
    _friendsSub = _firestore
        .collection("contacts")
        .doc(currentUser)
        .collection("friends")
        .snapshots()
        .listen((snapshot) {
          friendsIds.value = snapshot.docs.map((doc) => doc.id).toList();
        });
  }

  void fetchSentRequests() {
    _sentSub = _firestore
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
    _requestsSub = _firestore
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
    return usersMap[id] ?? PeopleModel(id: '', name: 'Unknown', image: '');
  }
}
