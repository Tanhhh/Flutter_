import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';

class SelectedDiscountProvider extends ChangeNotifier {
  Discount? _selectedDiscount;

  Discount? get selectedDiscount => _selectedDiscount;

  void setSelectedDiscount(Discount discount) {
    _selectedDiscount = discount;
    notifyListeners();
  }

  bool hasSelectedDiscount() {
    return _selectedDiscount != null;
  }

  bool isSelectedDiscount(Discount discount) {
    return _selectedDiscount == discount;
  }

  void resetSelectedDiscount() {
    _selectedDiscount = null;
    notifyListeners();
  }
}
