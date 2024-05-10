import 'package:cloud_firestore/cloud_firestore.dart';

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

  CustomerAddress copyWith({
    String? customerAddressId,
    String? name,
    String? phone,
    String? address,
    String? addressNote,
    DateTime? createDate,
    DateTime? updatedDate,
    String? customerId,
  }) {
    return CustomerAddress(
      customerAddressId: customerAddressId ?? this.customerAddressId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      addressNote: addressNote ?? this.addressNote,
      createDate: createDate ?? this.createDate,
      updatedDate: updatedDate ?? this.updatedDate,
      customerId: customerId ?? this.customerId,
    );
  }

  factory CustomerAddress.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomerAddress(
      customerAddressId: doc.id,
      name: data['name'],
      address: data['address'],
      addressNote: data['addressNote'],
      createDate: data['createDate'].toDate(),
      updatedDate: data['updatedDate'].toDate(),
      customerId: data['customerId'],
      phone: data['phone'],
    );
  }
}
