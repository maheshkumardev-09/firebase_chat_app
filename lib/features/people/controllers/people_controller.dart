import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/features/people/models/people_model.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 All users
  var users = <PeopleModel>[].obs;

  // 🔹 Search
  var searchText = "".obs;
  var isSearchOpen = false.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  // 🔥 Fetch users (real-time)
  void fetchUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      users.value = snapshot.docs.map((doc) {
        return PeopleModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 🔍 Filter users
  List<PeopleModel> get filteredUsers {
    if (searchText.value.isEmpty) return users;

    return users.where((user) {
      return user.name.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }

  // 🔄 Toggle search
  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) {
      searchText.value = "";
    }
  }
}
