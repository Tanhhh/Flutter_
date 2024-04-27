import 'package:flutter/material.dart';

import '../../../model/product_model.dart';

class CartRepository {
  List<Product> _cartItems = [];
  VoidCallback? onCartChanged;

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    if (onCartChanged != null) {
      onCartChanged!();
    }
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    if (onCartChanged != null) {
      onCartChanged!();
    }
  }

  int get itemCount => _cartItems.length;
}
