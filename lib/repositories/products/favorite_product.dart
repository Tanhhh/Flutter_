import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';

class FavoriteProductRepository {
  static final FavoriteProductRepository _instance =
      FavoriteProductRepository._internal();

  factory FavoriteProductRepository() {
    return _instance;
  }

  FavoriteProductRepository._internal();

  Future<void> addToFavorites(String productId, String userId) async {
    try {
      // Thêm mới vào mục yêu thích
      DocumentReference favoriteRef =
          await FirebaseFirestore.instance.collection('favoriteProducts').add({
        'customerId': userId,
        'productId': productId,
        'favoriteProductId':
            '', // Sẽ cập nhật lại thành document ID sau khi thêm mới
      });
      // Cập nhật favoriteProductId bằng document ID vừa tạo
      await favoriteRef.update({'favoriteProductId': favoriteRef.id});
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào mục yêu thích: $e');
    }
  }

  Future<void> removeFromFavorites(String productId, String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favoriteProducts')
          .where('customerId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Lỗi khi xóa sản phẩm khỏi mục yêu thích: $e');
    }
  }

  Stream<List<String>> getFavoriteProducts() {
    User? currentUser = UserRepository().getUserAuth();
    if (currentUser == null) return Stream.empty();

    return FirebaseFirestore.instance
        .collection('favoriteProducts')
        .where('customerId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['productId'] as String).toList());
  }

  // Kiểm tra xem sản phẩm có trong mục yêu thích của người dùng hay không
  Future<bool> isProductFavorite(String productId, String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favoriteProducts')
          .where('customerId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Lỗi khi kiểm tra sản phẩm yêu thích: $e');
      return false;
    }
  }
}
