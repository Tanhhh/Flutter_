class OrderNotification {
  final String orderId;
  final String status;
  final String message;

  OrderNotification({
    required this.orderId,
    required this.status,
    required this.message,
  });

  factory OrderNotification.fromJson(Map<String, dynamic> json) {
    return OrderNotification(
      orderId: json['orderId'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'message': message,
    };
  }
}
