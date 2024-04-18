import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String? customerId;
  final String customerName;
  final String customerEmail;
  final String customerPassword;
  final String? customerGender;
  final DateTime? customerBirthDay;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;
  final String customerAvatar;

  Customer({
    this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPassword,
    required this.customerGender,
    required this.customerBirthDay,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
    required this.customerAvatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPassword': customerPassword,
      'customerGender': customerGender,
      'customerBirthDay': customerBirthDay,
      'isActive': isActive,
      'createdBy': createdBy,
      'createDate': createDate,
      'updatedDate': updatedDate,
      'updatedBy': updatedBy,
      'customerAvatar': customerAvatar,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerPassword: map['customerPassword'],
      customerGender: map['customerGender'],
      customerBirthDay: map['customerBirthDay'] != null
          ? (map['customerBirthDay'] as Timestamp).toDate()
          : null,
      isActive: map['isActive'],
      createdBy: map['createdBy'],
      createDate: (map['createDate'] as Timestamp).toDate(),
      updatedDate: (map['updatedDate'] as Timestamp).toDate(),
      updatedBy: map['updatedBy'],
      customerAvatar: map['customerAvatar'],
    );
  }
}
