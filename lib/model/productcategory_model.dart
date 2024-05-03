import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategory {
  String? productCategoryId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;

  ProductCategory({
    this.productCategoryId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'ProductCategoryId': productCategoryId,
      'Name': name,
      'IsActive': isActive,
      'CreateBy': createdBy,
      'CreateDate': Timestamp.fromDate(createDate),
      'UpdatedDate': Timestamp.fromDate(updatedDate),
      'UpdateBy': updatedBy,
    };
  }

  factory ProductCategory.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductCategory(
      productCategoryId: doc.id,
      name: data['Name'],
      isActive: data['IsActive'],
      createdBy: data['CreateBy'],
      createDate: (data['CreateDate'] as Timestamp).toDate(),
      updatedDate: (data['UpdatedDate'] as Timestamp).toDate(),
      updatedBy: data['UpdateBy'],
    );
  }
}
