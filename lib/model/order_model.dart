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
  final DateTime? confirmDate;
  final DateTime? shipDate;
  final DateTime? successDate;
  final DateTime? cancelDate;
  final DateTime? returnDate;
  final String? paymentMethodId;
  final String? customerAddressId;
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
    this.confirmDate,
    this.cancelDate,
    this.returnDate,
    this.successDate,
    this.shipDate,
    this.paymentMethodId,
    required this.customerAddressId,
    this.userId,
    this.discountId,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Kiểm tra và lấy giá trị cho các trường ngày tháng
    DateTime? shipDate = data['shipDate'] != null
        ? (data['shipDate'] as Timestamp).toDate()
        : null;
    DateTime? successDate = data['successDate'] != null
        ? (data['successDate'] as Timestamp).toDate()
        : null;
    DateTime? cancelDate = data['cancelDate'] != null
        ? (data['cancelDate'] as Timestamp).toDate()
        : null;
    DateTime? returnDate = data['returnDate'] != null
        ? (data['returnDate'] as Timestamp).toDate()
        : null;
    DateTime? confirmDate = data['confirmDate'] != null
        ? (data['confirmDate'] as Timestamp).toDate()
        : null;

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
      confirmDate: confirmDate,
      shipDate: shipDate,
      successDate: successDate,
      cancelDate: cancelDate,
      returnDate: returnDate,
      paymentMethodId: data['paymentMethodId'] ?? '',
      customerAddressId: data['customerAddressId'] ?? '',
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
      'confirmDate': confirmDate,
      'paymentMethodId': paymentMethodId,
      'customerAddressId': customerAddressId,
      'userId': userId,
      'discountId': discountId,
      'shipDate': shipDate,
      'successDate': successDate,
      'cancelDate': cancelDate,
      'returnDate': returnDate,
    };
  }
}
