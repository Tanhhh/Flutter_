import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  Future<String?> getLatestImageUrl(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'customers_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      final firebase_storage.ListResult result = await ref.listAll();
      if (result.items.isEmpty) {
        return null; // Trả về null nếu không có ảnh nào trong thư mục
      }

      // Lấy ảnh mới nhất từ danh sách và trả về URL của nó
      final latestImageRef = result.items.first;
      final latestImageUrl = await latestImageRef.getDownloadURL();
      return latestImageUrl;
    } catch (e) {
      print('Error getting latest image URL: $e');
      return null;
    }
  }
}
