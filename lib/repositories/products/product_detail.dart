import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';
import '../../model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductRepository {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _availableSizeProductCollection =
      FirebaseFirestore.instance.collection('availablesizeproduct');

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

  Future<List<String>> getProductSizes(String productId) async {
    try {
      List<String> productSizes = [];

      QuerySnapshot snapshot = await _availableSizeProductCollection
          .where('productId', isEqualTo: productId)
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        // Lấy sizeProductId từ document
        String sizeProductId = doc['sizeProductId'];

        DocumentSnapshot sizeDoc = await FirebaseFirestore.instance
            .collection('sizeproduct')
            .doc(sizeProductId)
            .get();

        SizeProduct sizeProduct = SizeProduct.fromDocument(sizeDoc);

        // Thêm size vào danh sách
        productSizes.add(sizeProduct.name);
      }

      // Sắp xếp danh sách kích thước
      productSizes.sort((a, b) {
        // Kiểm tra nếu cả hai đều là số
        bool isANumeric = isNumeric(a);
        bool isBNumeric = isNumeric(b);

        // Nếu cả hai đều không phải số, sắp xếp theo bảng size
        if (!isANumeric && !isBNumeric) {
          return sizeOrder.indexOf(a) - sizeOrder.indexOf(b);
        }
        // Nếu chỉ có a là số
        else if (!isANumeric) {
          return -1; // Đặt a trước b
        }
        // Nếu chỉ có b là số
        else if (!isBNumeric) {
          return 1; // Đặt b trước a
        }
        // Nếu cả hai đều là số, sắp xếp theo thứ tự số
        else {
          return int.parse(a).compareTo(int.parse(b));
        }
      });

      return productSizes;
    } catch (e) {
      print('Error getting product sizes: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

// Danh sách thứ tự size
  List<String> sizeOrder = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

// Hàm kiểm tra xem một chuỗi có phải là số hay không
  bool isNumeric(String s) {
    if (s == '') {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
