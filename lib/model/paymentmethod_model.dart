import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethod {
  final String? paymentMethodId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;
  final String description;

  PaymentMethod({
    required this.paymentMethodId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
    required this.description,
  });

  factory PaymentMethod.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PaymentMethod(
      paymentMethodId: doc.id,
      name: data['name'] ?? '',
      isActive: data['isActive'] ?? false,
      createdBy: data['createdBy'] ?? '',
      createDate: (data['createDate'] as Timestamp).toDate(),
      updatedDate: (data['updatedDate'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
