import 'package:cloud_firestore/cloud_firestore.dart';

class Discount {
  final String? discountId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;
  final String description;
  final double value;
  final int quantity;
  final double price;

  Discount({
    required this.discountId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
    required this.description,
    required this.value,
    required this.quantity,
    required this.price,
  });

  // Phương thức tạo đối tượng Discount từ DocumentSnapshot
  factory Discount.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Discount(
      discountId: doc.id,
      name: data['name'],
      isActive: data['isActive'],
      createdBy: data['createdBy'],
      createDate: data['createDate'].toDate(),
      updatedDate: data['updatedDate'].toDate(),
      updatedBy: data['updatedBy'],
      description: data['description'],
      value: data['value'].toDouble(),
      quantity: data['quantity'],
      price: data['price'].toDouble(),
    );
  }
}
