import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final CollectionReference _productCollection =
    FirebaseFirestore.instance.collection('products');

Future<List<Product>> getProductsByNameKeyword(String keyword) async {
  try {
    // Loại bỏ khoảng trắng khỏi từ khóa

    // Chuyển đổi từ khóa thành chữ thường để tìm kiếm không phân biệt chữ hoa chữ thường
    String lowerCaseKeyword = keyword.toLowerCase();

    // Tìm các sản phẩm có trường "searchName" chứa từ khóa (không phân biệt chữ hoa chữ thường và khoảng trắng)
    QuerySnapshot productSnapshots = await _productCollection
        .where('searchName', isGreaterThanOrEqualTo: lowerCaseKeyword)
        .where('searchName', isLessThan: lowerCaseKeyword + 'z')
        .get();

    List<Product> products = [];
    for (DocumentSnapshot productSnapshot in productSnapshots.docs) {
      Product product = Product.fromDocument(productSnapshot);
      List<String> imageUrls = await getImageUrls(product.productId);
      product.imageUrls = imageUrls;
      products.add(product);
    }
    return products;
  } catch (e) {
    print('Error getting products by name keyword: $e');
    return [];
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
