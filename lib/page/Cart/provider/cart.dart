import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CartRepository extends ChangeNotifier {
  final List<Cart> _cartItems = [];
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
  double calculateShippingFee(String address) {
    if (!address.toLowerCase().contains('hồ chí minh')) {
      return 100000;
    } else {
      return 0;
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
      notifyListeners();

      print('Updated Cart Items:');
      for (var item in _cartItems) {
        print(
            'Product Name: ${item.productName}, Size Name: ${item.sizeName}, Quantity: ${item.quantity}, Price: ${item.price}');
      }
      print('Product added to cart successfully');
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<String> getProductIdByName(String name) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final productData = snapshot.docs.first.data();
        final String productId = productData['productId'];
        return productId;
      } else {
        throw Exception('Size with name $name not found!');
      }
    } catch (e) {
      throw Exception('Error fetching size: $e');
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
      String storagePath = 'products_images/$documentId';

      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      final firebase_storage.ListResult result = await ref.listAll();

      List<String> imageUrls = [];
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return [];
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
    notifyListeners();
  }

  int get itemCount => _cartItems.length;

  Future<void> clearCartItems() async {
    _cartItems.clear();
    notifyListeners();
  }

  void update(CartRepository newCartRepository) {
    // Cập nhật các giá trị của CartRepository với các giá trị từ newCartRepository
    // Ví dụ:
    // _cartItems = newCartRepository.cartItems;
    // Hoặc bất kỳ cập nhật nào khác bạn cần thực hiện
    // Sau khi cập nhật, hãy thông báo cho người nghe biết rằng có sự thay đổi
    notifyListeners();
  }

  int _selectedQuantity = 0;
  double _totalPrice = 0.0;

  int get selectedQuantity => _selectedQuantity;
  double get totalPrice => _totalPrice;

  void setSelectedQuantity(int quantity, double price) {
    _selectedQuantity = quantity;
    _totalPrice = price * quantity;
    notifyListeners();
  }

  void updateCartItem({
    required String productName,
    required double price,
    required int quantity,
    required String sizeName,
    required String imageUrl,
  }) async {
    for (Cart product in _cartItems) {
      if (product.productName == productName &&
          product.sizeName == sizeName &&
          product.image == imageUrl) {
        product.productName = productName;
        product.sizeName = sizeName;
        product.image = imageUrl;
        product.quantity = quantity;
        product.price = price;
        break;
      }
    }

    // In ra các sản phẩm trong giỏ hàng sau khi cập nhật

    notifyListeners();
    ();
    print('Updated Cart Items:');
    for (var item in _cartItems) {
      print(
          'Product Name: ${item.productName}, Size Name: ${item.sizeName}, Quantity: ${item.quantity}, Price: ${item.price}');
    }
  }

  double get cartSubTotal => getTotalPrice();
  void increaseQuantityByProductNameAndSizeName({
    required String productName,
    required String sizeName,
  }) {
    for (Cart product in _cartItems) {
      if (product.productName == productName && product.sizeName == sizeName) {
        // Tăng số lượng của sản phẩm
        product.quantity++;

        // Tính lại giá của sản phẩm dựa trên số lượng mới
        product.price =
            (product.price / (product.quantity - 1)) * product.quantity;

        notifyListeners();
        return;
      }
    }
    print(
        'Product with name $productName and size $sizeName not found in cart.');
  }

  void decreaseQuantityByProductNameAndSizeName({
    required String productName,
    required String sizeName,
  }) {
    for (Cart product in _cartItems) {
      if (product.productName == productName && product.sizeName == sizeName) {
        // Giảm số lượng của sản phẩm, nếu số lượng hiện tại lớn hơn 1
        if (product.quantity > 1) {
          product.quantity--;

          // Tính lại giá của sản phẩm dựa trên số lượng mới
          product.price =
              (product.price / (product.quantity + 1)) * product.quantity;

          notifyListeners();
        } else {
          print('Cannot decrease quantity. Minimum quantity reached.');
        }
        return;
      }
    }
    print(
        'Product with name $productName and size $sizeName not found in cart.');
  }

  List<Cart> _selectedItems = [];
  List<Cart> get selectedItems => _selectedItems;
  void toggleSelectedItem(Cart item, {bool select = true}) {
    if (select) {
      if (!_selectedItems.any((selectedItem) =>
          selectedItem.productName == item.productName &&
          selectedItem.sizeName == item.sizeName)) {
        _selectedItems.add(item);
      }
    } else {
      _selectedItems.removeWhere((selectedItem) =>
          selectedItem.productName == item.productName &&
          selectedItem.sizeName == item.sizeName);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    for (var cartItem in _selectedItems) {
      total += cartItem.price;
    }
    notifyListeners();

    return total;
  }

  void clearSelectedItems() {
    _selectedItems = [];
    notifyListeners();
  }
}
