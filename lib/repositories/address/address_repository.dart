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

  Future<List<CustomerAddress>> getAddressesByCustomerId(
      String customerId) async {
    List<CustomerAddress> addresses = [];
    try {
      QuerySnapshot snapshot = await _addressesCollection
          .where('customerId', isEqualTo: customerId)
          .get();
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
      print('Error getting addresses by customer id: $error');
    }
    return addresses;
  }

  Future<void> addAddress(CustomerAddress address) async {
    try {
      CustomerAddress addressCopy = CustomerAddress(
        name: address.name,
        phone: address.phone,
        address: address.address,
        addressNote: address.addressNote,
        createDate: address.createDate,
        updatedDate: address.updatedDate,
        customerId: address.customerId,
        customerAddressId: '',
      );
      DocumentReference docRef = await _addressesCollection.add({
        'name': addressCopy.name,
        'phone': addressCopy.phone,
        'address': addressCopy.address,
        'addressNote': addressCopy.addressNote,
        'createDate': addressCopy.createDate,
        'updatedDate': addressCopy.updatedDate,
        'customerId': addressCopy.customerId,
      });
      String newId = docRef.id;
      addressCopy = addressCopy.copyWith(customerAddressId: newId);
      await docRef.update({'customerAddressId': newId});
    } catch (error) {
      print('Error adding address: $error');
    }
  }

  Future<void> editAddress(CustomerAddress address) async {
    try {
      await _addressesCollection.doc(address.customerAddressId).update({
        'name': address.name,
        'phone': address.phone,
        'address': address.address,
        'addressNote': address.addressNote,
        'updatedDate': address.updatedDate,
      });
    } catch (error) {
      print('Error editing address: $error');
    }
  }

  Future<void> deleteAddress(String customerAddressId) async {
    try {
      await _addressesCollection.doc(customerAddressId).delete();
    } catch (error) {
      print('Error deleting address: $error');
    }
  }

  Future<String?> getNextAddressId() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('customeraddress')
          .orderBy('customerAddressId', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastAddressId =
            querySnapshot.docs.first['customerAddressId'] as String;
        final lastId = int.tryParse(lastAddressId);
        if (lastId != null) {
          final nextId = (lastId + 1).toString();
          return nextId;
        } else {
          return null;
        }
      } else {
        return '1';
      }
    } catch (e) {
      print('Error getting next address ID: $e');
      return null;
    }
  }

  Future<CustomerAddress?> getAddressByCustomerAddressId(
      String customerAddressId) async {
    try {
      QuerySnapshot snapshot = await _addressesCollection
          .where('customerAddressId', isEqualTo: customerAddressId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
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
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting address by customerAddressId: $error');
      return null;
    }
  }
}
