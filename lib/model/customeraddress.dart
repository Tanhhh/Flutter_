class CustomerAddress {
  final String? customerAddressId;
  final String name;
  final String phone;
  final String address;
  final String addressNote;
  final DateTime createDate;
  final DateTime updatedDate;
  final String customerId;

  CustomerAddress({
    required this.customerAddressId,
    required this.name,
    required this.phone,
    required this.address,
    required this.addressNote,
    required this.createDate,
    required this.updatedDate,
    required this.customerId,
  });
}
