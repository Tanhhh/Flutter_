import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductRepository {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot =
          await _productCollection.where('isActive', isEqualTo: true).get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        String imageUrl = await getImageUrl(doc['imageProduct']);
        product.imageProduct = imageUrl; // Gán URL của ảnh cho sản phẩm\
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getHotProducts() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isHot', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        String imageUrl = await getImageUrl(doc['imageProduct']);
        product.imageProduct = imageUrl; // Gán URL của ảnh cho sản phẩm\
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getSaleProductDocumentIds() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isSale', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        String imageUrl = await getImageUrl(doc['imageProduct']);
        product.imageProduct = imageUrl; // Gán URL của ảnh cho sản phẩm\
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getNewProductsWithImages() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isNew', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        String imageUrl = await getImageUrl(doc['imageProduct']);
        product.imageProduct = imageUrl; 
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<String> getImageUrl(String imageName) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('products_images/$imageName');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting image URL: $e');
      return ''; // Trả về chuỗi rỗng nếu có lỗi
    }
  }
}
