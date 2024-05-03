import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/product_model.dart';
import 'dart:convert';

class CartRepository extends ChangeNotifier {
  List<AvailableSizeProduct> _cartItems = [];
  List<AvailableSizeProduct> get cartItems => _cartItems;

  static const String cartItemsKey = 'cartItems';

  CartRepository() {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList(cartItemsKey);
    if (cartItemsJson != null) {
      _cartItems = cartItemsJson
          .map((json) => AvailableSizeProduct.fromDocument(jsonDecode(json)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson =
        _cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(cartItemsKey, cartItemsJson);
  }

  void addToCart({
    required String productId,
    required String sizeName,
    required int quantity,
  }) async {
    try {
      String sizeId = await getSizeIdByName(sizeName);

      bool isExistingProduct = false;
      for (AvailableSizeProduct product in _cartItems) {
        if (product.productId == productId && product.sizeProductId == sizeId) {
          product.quantity += quantity;
          isExistingProduct = true;
          break;
        }
      }

      if (!isExistingProduct) {
        AvailableSizeProduct selectedProduct = AvailableSizeProduct(
          id: null,
          productId: productId,
          sizeProductId: sizeId,
          quantity: quantity,
        );
        _cartItems.add(selectedProduct);
      }

      await _saveCartItems();
      print('Product added to cart successfully');
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<String> getSizeIdByName(String sizeName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('sizeproduct')
          .where('name', isEqualTo: sizeName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        throw Exception('Size with name $sizeName not found!');
      }
    } catch (e) {
      throw Exception('Error fetching size: $e');
    }
  }

  void removeFromCart(AvailableSizeProduct product) {
    _cartItems.remove(product);
  }

  int get itemCount => _cartItems.length;

  // Add a method to calculate total price of items in the cart
  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in _cartItems) {
      getProductPrice(item.productId).then((price) {
        totalPrice += item.quantity * price;
      });
    }
    return totalPrice;
  }

  Future<double> getProductPrice(String productId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (snapshot.exists) {
        Product product = Product.fromDocument(snapshot);
        // Check if the product is on sale and has a price sale
        if (product.isSale && product.priceSale > 0) {
          return product.priceSale;
        } else {
          return product.price;
        }
      } else {
        throw Exception('Product with ID $productId not found!');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<String> getProductNamePrice(String productId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (snapshot.exists) {
        Product product = Product.fromDocument(snapshot);
        return product.name;
      } else {
        throw Exception('Product with ID $productId not found!');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Add a method to clear the cart
  void clearCart() {
    _cartItems.clear();
  }
}
