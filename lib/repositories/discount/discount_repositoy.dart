import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';

class DiscountRepository {
  final CollectionReference _discountCollection =
      FirebaseFirestore.instance.collection('discount');

  Future<List<Discount>> getActiveDiscounts() async {
    List<Discount> activeDiscounts = [];
    try {
      QuerySnapshot snapshot =
          await _discountCollection.where('isActive', isEqualTo: true).get();
      activeDiscounts = snapshot.docs.map((doc) {
        return Discount(
          discountId: doc.id,
          name: doc['name'],
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          updatedBy: doc['updatedBy'],
          description: doc['description'],
          value: doc['value'],
          quantity: doc['quantity'],
          price: doc['price'],
        );
      }).toList();
    } catch (error) {
      // Xử lý khi gặp lỗi
      print('Error getting active discounts: $error');
    }
    return activeDiscounts;
  }
}
