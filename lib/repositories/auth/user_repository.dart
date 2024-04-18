import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  DocumentSnapshot? currentUser;

  void setUser(DocumentSnapshot? user) {
    currentUser = user;
  }

  DocumentSnapshot? getUser() {
    return currentUser;
  }

  void clearUser() {
    currentUser = null;
  }
}
