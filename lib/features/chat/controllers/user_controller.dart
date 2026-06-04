import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/core/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  var usersList = <UserModel>[].obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    fetchAcceptedUsers();
    super.onInit();
  }

  void fetchAcceptedUsers() {
    _firestore
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((snapshot) async {
          Set<String> friendIds = {};
          for (var doc in snapshot.docs) {
            var data = doc.data();
            if (data['senderId'] == currentUser) {
              friendIds.add(data['receiverId']);
            } else if (data['receiverId'] == currentUser) {
              friendIds.add(data['senderId']);
            }
          }
          print("My UID: $currentUser");
          print("Friend IDs: $friendIds");

          if (friendIds.isEmpty) {
            usersList.value = [];
            isLoading.value = false;
            return;
          }
          List<UserModel> usersWithMessages = [];
          isLoading.value = true;
          final userDocs = await _firestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: friendIds.toList())
              .get();
          for (var doc in userDocs.docs) {
            // final usedata = UserModel.fromMap(doc.data());
            final data = doc.data();
            data['uid'] = doc.id;
            final usedata = UserModel.fromMap(data);
            final outherUid = usedata.uid;
            final chatId = currentUser.compareTo(outherUid) < 0
                ? "${currentUser}_$outherUid"
                : "${outherUid}_$currentUser";
            final chatDoc = await _firestore
                .collection('chats')
                .doc(chatId)
                .get();
            final lastMessage = chatDoc.data()?['lastMessage'] ?? '';
            final lastMessageTime = chatDoc.data()?['lastMessageTime'] ?? '';
            // final lastMessageTime =
            //     (chatDoc.data()?['lastMessageTime'] as Timestamp?)?.toDate() ??
            //     DateTime.now();

            usersWithMessages.add(
              UserModel(
                uid: usedata.uid,
                name: usedata.name,
                email: usedata.email,
                image: usedata.image,
                lastMessage: lastMessage,
                lastMessageTime: lastMessageTime,
              ),
            );
          }
          usersList.value = usersWithMessages;
          isLoading.value = false;
        });
  }
}
