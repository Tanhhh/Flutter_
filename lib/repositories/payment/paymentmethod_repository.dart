import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';

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
}
