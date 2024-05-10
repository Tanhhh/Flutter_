import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  final String orderId;
  final String productId;
  final double price;
  final int quantity;

  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
  });

  factory OrderDetail.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderDetail(
      orderId: data['orderId'] ?? '',
      productId: data['availableSizeProductId'] ?? '',
      price: data['price'] ?? 0.0,
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'availableSizeProductId': productId,
      'price': price,
      'quantity': quantity,
    };
  }
}
