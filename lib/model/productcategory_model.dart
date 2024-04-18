class ProductCategory {
  final String? productCategoryId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;

  ProductCategory({
    required this.productCategoryId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
  });
}
