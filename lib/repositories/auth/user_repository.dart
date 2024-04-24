import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();
  User? currentUserAuth;
  DocumentSnapshot? currentUser;

  void setUserAuth(User? user) {
    currentUserAuth = user;
  }

  DocumentSnapshot? getUser() {
    return currentUser;
  }

  void clearUserAuth() {
    currentUserAuth = null;
  }

  User? getUserAuth() {
    return currentUserAuth;
  }

  Future<DocumentSnapshot?> getUserCloud(User? currentUser) async {
    if (currentUser == null) return null;

    try {
      // Thực hiện truy vấn Firestore để lấy document từ collection 'customers' với điều kiện customerId trùng với user UID
      return await FirebaseFirestore.instance
          .collection('customers')
          .doc(currentUser.uid)
          .get();
    } catch (e) {
      print('Lỗi khi lấy thông tin người dùng từ Firestore: $e');
      return null;
    }
  }
}
