import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductRepository {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot productSnapshot =
          await _productCollection.doc(productId).get();

      if (productSnapshot.exists) {
        Product product = Product.fromDocument(productSnapshot);
        List<String> imageUrls = await getImageUrls(productId);
        product.imageUrls = imageUrls;
        return product;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'products_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
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
}
