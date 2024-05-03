import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';

class ProductCategoryRepository {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('productcategory');

  Future<DocumentReference> addCategory(ProductCategory category) async {
    try {
      DocumentReference docRef =
          await _categoryCollection.add(category.toMap());

      // Gán Document ID mới cho thuộc tính productCategoryId sau khi thêm mới thành công
      await docRef.update({'ProductCategoryId': docRef.id});

      return docRef;
    } catch (e) {
      print('Error adding category: $e');
      throw e; // Đảm bảo rằng lỗi vẫn được throw để có thể xử lý ở nơi gọi hàm
    }
  }

  Stream<List<ProductCategory>> getCategoryStream() {
    try {
      return _categoryCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => ProductCategory.fromDocument(doc))
          .toList());
    } catch (e) {
      print('Error getting category stream: $e');
      return Stream.value([]);
    }
  }

  Future<void> updateCategory(ProductCategory category) async {
    try {
      await _categoryCollection
          .doc(category.productCategoryId)
          .update(category.toMap());
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryCollection.doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
