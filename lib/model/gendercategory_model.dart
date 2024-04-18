class GenderCategory {
  final String? genderCategoryId;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;

  GenderCategory({
    required this.genderCategoryId,
    required this.name,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
  });
}
