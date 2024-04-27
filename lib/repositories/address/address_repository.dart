import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';

class AddressRepository {
  final CollectionReference _addressesCollection =
      FirebaseFirestore.instance.collection('customeraddress');

  Future<List<CustomerAddress>> getAddresses() async {
    List<CustomerAddress> addresses = [];
    try {
      QuerySnapshot snapshot = await _addressesCollection.get();
      addresses = snapshot.docs.map((doc) {
        return CustomerAddress(
          customerAddressId: doc.id,
          name: doc['name'],
          phone: doc['phone'],
          address: doc['address'],
          addressNote: doc['addressNote'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          customerId: doc['customerId'],
        );
      }).toList();
    } catch (error) {
      // Xử lý khi gặp lỗi
      print('Error getting addresses: $error');
    }
    return addresses;
  }

  Future<void> addAddress(CustomerAddress address) async {
    try {
      await _addressesCollection.add({
        'name': address.name,
        'phone': address.phone,
        'address': address.address,
        'addressNote': address.addressNote,
        'createDate': address.createDate,
        'updatedDate': address.updatedDate,
        'customerId': address.customerId,
      });
    } catch (error) {
      // Xử lý khi gặp lỗi
      print('Error adding address: $error');
    }
  }

  Future<String?> getNextAddressId() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('customer_address')
          .orderBy('customerAddressId', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastAddressId =
            querySnapshot.docs.first['customerAddressId'] as String;
        final nextId = (int.parse(lastAddressId) + 1).toString();
        return nextId;
      } else {
        return '1';
      }
    } catch (e) {
      print('Error getting next address ID: $e');
      return null;
    }
  }
}
