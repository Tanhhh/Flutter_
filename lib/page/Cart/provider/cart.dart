import 'package:flutter/material.dart';

import '../../../model/product_model.dart';

class CartRepository {
  List<Product> _cartItems = []; // Danh sách sản phẩm trong giỏ hàng

  // Lấy danh sách sản phẩm trong giỏ hàng
  List<Product> get cartItems => _cartItems;

  // Callback để thông báo khi có thay đổi số lượng sản phẩm trong giỏ hàng
  VoidCallback? onCartChanged;

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    _cartItems.add(product);
    if (onCartChanged != null) {
      onCartChanged!();
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(Product product) {
    _cartItems.remove(product);
    if (onCartChanged != null) {
      onCartChanged!();
    }
  }

  // Đếm số lượng sản phẩm trong giỏ hàng
  int get itemCount => _cartItems.length;
}
