import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? orderId;
  final String? note;
  final bool? isSuccess;
  final bool? isCancel;
  final bool? isReturn;
  final bool? isPay;
  final bool? isConfirm;
  final bool? isShip;
  final String? status;
  final double totalPayment;
  final DateTime? createDate;
  final DateTime? updatedDate;
  final String? paymentMethodId;
  final String customerId;
  final String? userId;
  final String? discountId;

  OrderModel({
    this.orderId,
    this.note,
    this.isSuccess,
    this.isCancel,
    this.isReturn,
    this.isPay,
    this.isConfirm,
    this.isShip,
    this.status,
    required this.totalPayment,
    this.createDate,
    this.updatedDate,
    this.paymentMethodId,
    required this.customerId,
    this.userId,
    this.discountId,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      note: data['note'] ?? '',
      isSuccess: data['isSuccess'] ?? false,
      isCancel: data['isCancel'] ?? false,
      isReturn: data['isReturn'] ?? false,
      isPay: data['isPay'] ?? false,
      isConfirm: data['isConfirm'] ?? false,
      isShip: data['isShip'] ?? false,
      status: data['status'] ?? '',
      totalPayment: data['totalPayment'] ?? 0.0,
      createDate: (data['createDate'] as Timestamp).toDate(),
      updatedDate: (data['updatedDate'] as Timestamp).toDate(),
      paymentMethodId: data['paymentMethodId'] ?? '',
      customerId: data['customerId'] ?? '',
      userId: data['userId'] ?? '',
      discountId: data['discountId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'isSuccess': isSuccess,
      'isCancel': isCancel,
      'isReturn': isReturn,
      'isPay': isPay,
      'isConfirm': isConfirm,
      'isShip': isShip,
      'status': status,
      'totalPayment': totalPayment,
      'createDate': createDate,
      'updatedDate': updatedDate,
      'paymentMethodId': paymentMethodId,
      'customerId': customerId,
      'userId': userId,
      'discountId': discountId,
    };
  }
}
