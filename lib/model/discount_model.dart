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
}
