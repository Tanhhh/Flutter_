import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PaymentMethodRepository {
  final CollectionReference _paymentMethodsCollection =
      FirebaseFirestore.instance.collection('paymentmethods');

  Future<List<PaymentMethod>> getPaymentMethods() async {
    List<PaymentMethod> paymentMethods = [];
    try {
      QuerySnapshot snapshot = await _paymentMethodsCollection.get();
      paymentMethods = snapshot.docs.map((doc) {
        return PaymentMethod(
          paymentMethodId: doc.id,
          name: doc['name'],
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          updatedBy: doc['updatedBy'],
          description: doc['description'],
        );
      }).toList();
    } catch (error) {
      // Xử lý khi gặp lỗi
      print('Error getting payment methods: $error');
    }
    return paymentMethods;
  }

  Future<String?> getImageUrl(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'paymentmethods_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các tệp tin trong thư mục
      final firebase_storage.ListResult result = await ref.list();

      // Nếu có ít nhất một tệp tin trong thư mục, trả về URL của tệp tin đầu tiên
      if (result.items.isNotEmpty) {
        final imageUrl = await result.items.first.getDownloadURL();
        return imageUrl;
      } else {
        // Nếu không có tệp tin nào trong thư mục, trả về null
        return null;
      }
    } catch (e) {
      print('Error getting image URL: $e');
      return null; // Trả về null nếu có lỗi
    }
  }
}
