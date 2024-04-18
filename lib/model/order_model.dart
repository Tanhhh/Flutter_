class Order {
  final String? orderId;
  final String note;
  final bool isSuccess;
  final bool isCancel;
  final bool isReturn;
  final bool isPay;
  final bool isConfirm;
  final bool isShip;
  final String status;
  final double totalPayment;
  final DateTime createDate;
  final DateTime updatedDate;
  final String paymentMethodId;
  final String customerId;
  final String userId;

  Order({
    required this.orderId,
    required this.note,
    required this.isSuccess,
    required this.isCancel,
    required this.isReturn,
    required this.isPay,
    required this.isConfirm,
    required this.isShip,
    required this.status,
    required this.totalPayment,
    required this.createDate,
    required this.updatedDate,
    required this.paymentMethodId,
    required this.customerId,
    required this.userId,
  });
}
