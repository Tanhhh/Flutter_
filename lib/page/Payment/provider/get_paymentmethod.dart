import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';

class SelectedPaymentProvider extends ChangeNotifier {
  PaymentMethod? _selectedPayment;

  PaymentMethod? get selectedPayment => _selectedPayment;

  void setSelectedPayment(PaymentMethod paymentMethod) {
    _selectedPayment = paymentMethod;
    notifyListeners();
  }

  bool hasSelectedPayment() {
    return _selectedPayment != null;
  }

  bool isSelectedPayment(PaymentMethod paymentMethod) {
    return _selectedPayment == paymentMethod;
  }

  void resetSelectedPayment() {
    _selectedPayment = null;
    notifyListeners();
  }
}
