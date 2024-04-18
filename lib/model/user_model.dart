class User {
  final String userId;
  final String name;
  final String account;
  final String password;
  final String imageUser;
  final String phone;
  final String email;
  final String address;
  final DateTime birthDay;
  final bool isAdmin;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final String updatedBy;
  final String gender;

  User({
    required this.userId,
    required this.name,
    required this.account,
    required this.password,
    required this.imageUser,
    required this.phone,
    required this.email,
    required this.address,
    required this.birthDay,
    required this.isAdmin,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.updatedBy,
    required this.gender,
  });
}
