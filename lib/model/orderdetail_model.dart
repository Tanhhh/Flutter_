class OrderDetail {
  final String? orderId;
  final String? productId;
  final double price;
  final int quantity;

  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
  });
}
