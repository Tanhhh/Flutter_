import 'package:flutter/material.dart';

class TotalPriceProvider extends ChangeNotifier {
  double _totalPrice = 0;

  double get totalPrice => _totalPrice;

  void setTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
    notifyListeners();
  }

  void reloadTotalPrice(double newTotalPrice) {
    _totalPrice = newTotalPrice;
    notifyListeners();
  }

  bool hasValue() {
    return _totalPrice != 0;
  }
}
