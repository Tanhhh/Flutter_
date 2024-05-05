import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CartRepository extends ChangeNotifier {
  List<Cart> _cartItems = [];
  List<Cart> get cartItems => _cartItems;

  // Thêm trường value
  late CartRepository _value;

  // Getter cho value
  CartRepository get value => _value;

  set value(CartRepository newValue) {
    _value = newValue;
    notifyListeners();
  }

  static const String cartItemsKey = 'cartItems';
  Future<void> _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Chuyển đổi danh sách sản phẩm thành danh sách chuỗi JSON
    List<String> cartItemsJson =
        _cartItems.map((item) => jsonEncode(item.toJson())).toList();
    // Lưu danh sách sản phẩm vào SharedPreferences
    await prefs.setStringList(cartItemsKey, cartItemsJson);
  }

  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList(cartItemsKey);
    if (cartItemsJson != null) {
      _cartItems = cartItemsJson
          .map((itemJson) => Cart.fromMap(jsonDecode(itemJson)))
          .toList();
    }
  }

  void addToCart({
    required String productId,
    required String sizeName,
    required int quantity,
  }) async {
    try {
      String productName = await getProductNameById(productId);
      double price = await getProductPriceById(productId);
      List<String> imageUrls = await getImageUrls(productId);
      String imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';
      bool isExistingProduct = false;
      for (Cart product in _cartItems) {
        if (product.productName == productName &&
            product.sizeName == sizeName) {
          product.quantity += quantity;
          product.price = price * product.quantity;
          isExistingProduct = true;
          break;
        }
      }

      if (!isExistingProduct) {
        Cart selectedProduct = Cart(
          productName: productName,
          sizeName: sizeName,
          quantity: quantity,
          price: price * quantity,
          image: imageUrl,
        );
        _cartItems.add(selectedProduct);
        print(_cartItems.length);
      }

      await _saveCartItems();
      print('Product added to cart successfully');
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<String> getProductNameById(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productId', isEqualTo: id)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final productData = snapshot.docs.first.data();
        final String productName = productData['name'];
        return productName;
      } else {
        throw Exception('Size with name $id not found!');
      }
    } catch (e) {
      throw Exception('Error fetching size: $e');
    }
  }

  Future<double> getProductPriceById(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productId', isEqualTo: id)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final productData = snapshot.docs.first.data();
        final bool isSale = productData['isSale'] ?? false;
        final double priceSale = productData['priceSale'] ?? 0;
        final double price = productData['price'] ?? 0;

        if (isSale && priceSale > 0) {
          return priceSale;
        } else {
          return price;
        }
      } else {
        throw Exception('Product with ID $id not found!');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'products_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
      final firebase_storage.ListResult result = await ref.listAll();

      // Lưu danh sách URL của các hình ảnh vào một danh sách
      List<String> imageUrls = [];
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  void removeFromCart({
    required String productName,
    required double price,
    required String imageUrl,
    required int quantity,
    required String sizeName,
  }) {
    _cartItems.removeWhere((cartItem) =>
        cartItem.productName == productName &&
        cartItem.price == price &&
        cartItem.image == imageUrl &&
        cartItem.quantity == quantity &&
        cartItem.sizeName == sizeName);
    _saveCartItems();
  }

  int get itemCount => _cartItems.length;

  Future<void> clearCartItems() async {
    _cartItems.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartItemsKey);
  }

  void update(CartRepository newCartRepository) {
    // Cập nhật các giá trị của CartRepository với các giá trị từ newCartRepository
    // Ví dụ:
    // _cartItems = newCartRepository.cartItems;
    // Hoặc bất kỳ cập nhật nào khác bạn cần thực hiện
    // Sau khi cập nhật, hãy thông báo cho người nghe biết rằng có sự thay đổi
    notifyListeners();
  }
}
