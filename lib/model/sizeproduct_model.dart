import 'package:cloud_firestore/cloud_firestore.dart';

class SizeProduct {
  final String? sizeProductId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;

  SizeProduct({
    this.sizeProductId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
  });

  factory SizeProduct.fromDocument(DocumentSnapshot doc) {
    return SizeProduct(
      sizeProductId: doc.id,
      name: doc['name'],
      isActive: doc['isActive'],
      createdBy: doc['createdBy'],
      createDate: doc['createDate'].toDate(),
      updatedDate: doc['updatedDate'].toDate(),
      updatedBy: doc['updatedBy'],
    );
  }
}
