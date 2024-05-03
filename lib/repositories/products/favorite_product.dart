import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FavoriteProductRepository {
  static final FavoriteProductRepository _instance =
      FavoriteProductRepository._internal();

  factory FavoriteProductRepository() {
    return _instance;
  }

  FavoriteProductRepository._internal();
  Future<void> addToFavorites(String productId, String userId) async {
    try {
      // Kiểm tra xem sản phẩm đã được thêm vào mục yêu thích của người dùng chưa
      bool isFavorite = await isProductFavorite(productId, userId);
      if (isFavorite) {
        print('Sản phẩm đã tồn tại trong mục yêu thích của người dùng');
        return;
      }

      // Thêm mới vào mục yêu thích
      DocumentReference favoriteRef =
          await FirebaseFirestore.instance.collection('favoriteProducts').add({
        'customerId': userId,
        'productId': productId,
        'favoriteProductId': '',
      });
      await favoriteRef.update({'favoriteProductId': favoriteRef.id});
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào mục yêu thích: $e');
    }
  }

  Future<int> countFavoriteProducts(String customerId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favoriteProducts')
          .where('customerId', isEqualTo: customerId)
          .get();
      print(customerId);

      return querySnapshot.docs.length;
    } catch (e) {
      print('Lỗi khi đếm số lượng sản phẩm yêu thích: $e');
      return 0;
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

  Stream<List<Product>> getFavoriteProducts(String customerId) {
    return FirebaseFirestore.instance
        .collection('favoriteProducts')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .asyncMap((snapshot) async {
      // Lấy danh sách productId từ snapshot.docs
      List<String> productIds =
          snapshot.docs.map((doc) => doc['productId'] as String).toList();

      // Lấy các sản phẩm từ collection 'products' dựa trên danh sách productId
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      // Chuyển đổi danh sách sản phẩm từ documents sang đối tượng Product
      List<Product> products = [];
      for (var doc in productsSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        List<String> imageUrls = await getImageUrls(product.productId);
        product.imageUrls = imageUrls;
        products.add(product);
      }

      return products;
    });
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'products_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      final firebase_storage.ListResult result = await ref.listAll();

      // Lưu danh sách URL của các hình ảnh vào một danh sách
      List<String> imageUrls = [];
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
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
