class Product {
  final String? productId;
  final String name;
  final String description;
  final double price;
  final double priceSale;
  final int quantity;
  final String imageProduct;
  final bool isNew;
  final bool isSale;
  final bool isHot;
  final bool isSoldOut;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final int rating;
  final String sizeProductId;
  final String genderCategoryId;
  final String productCategoryId;
  final String discountId;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.priceSale,
    required this.quantity,
    required this.imageProduct,
    required this.isNew,
    required this.isSale,
    required this.isHot,
    required this.isSoldOut,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.rating,
    required this.sizeProductId,
    required this.genderCategoryId,
    required this.productCategoryId,
    required this.discountId,
  });
}
