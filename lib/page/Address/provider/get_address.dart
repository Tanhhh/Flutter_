import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';

class SelectedAddressProvider extends ChangeNotifier {
  CustomerAddress? _selectedAddress;

  CustomerAddress? get selectedAddress => _selectedAddress;

  void setSelectedAddress(CustomerAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  bool hasSelectedAddress() {
    return _selectedAddress != null;
  }

  void resetSelectedAddress() {
    _selectedAddress = null;
    notifyListeners();
  }
}
