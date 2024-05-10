import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class OrderDetailRepository {
  final CollectionReference orderDetailsCollection =
      FirebaseFirestore.instance.collection('orderdetails');
  final CollectionReference availableSizeProductCollection =
      FirebaseFirestore.instance.collection('availablesizeproduct');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference sizeProductCollection =
      FirebaseFirestore.instance.collection('sizeproduct');
  final CollectionReference discountCollection =
      FirebaseFirestore.instance.collection('discount');
  final CollectionReference addressCollection =
      FirebaseFirestore.instance.collection('customeraddress');

  Future<List<Cart>> getOrderDetailsByOrderId(String orderId) async {
    QuerySnapshot querySnapshot =
        await orderDetailsCollection.where('orderId', isEqualTo: orderId).get();

    List<OrderDetail> orderDetails = [];

    querySnapshot.docs.forEach((doc) {
      orderDetails.add(OrderDetail.fromFirestore(doc));
    });
    List<Cart> cart = [];
    for (OrderDetail orderDetail in orderDetails) {
      AvailableSizeProduct? availableProduct =
          await getAvailableSizeProductById(orderDetail.productId);
      Product? product = await getProductById(availableProduct!.productId);
      SizeProduct? sizeProduct =
          await getSizeProductById(availableProduct.sizeProductId);
      cart.add(Cart(
          productName: product!.name,
          sizeName: sizeProduct!.name,
          quantity: orderDetail.quantity,
          price: orderDetail.price,
          image: product.imageUrls[0]));
    }
    return cart;
  }

  Future<CustomerAddress?> getAddressById(String customerAddressId) async {
    try {
      DocumentSnapshot doc =
          await addressCollection.doc(customerAddressId).get();

      if (doc.exists) {
        return CustomerAddress.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving available size product: $e');
      return null;
    }
  }

  Future<AvailableSizeProduct?> getAvailableSizeProductById(
      String availableSizeProductId) async {
    try {
      DocumentSnapshot doc = await availableSizeProductCollection
          .doc(availableSizeProductId)
          .get();

      if (doc.exists) {
        return AvailableSizeProduct.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving available size product: $e');
      return null;
    }
  }

  Future<Discount?> getDiscountProductById(String discountId) async {
    try {
      DocumentSnapshot doc = await discountCollection.doc(discountId).get();

      if (doc.exists) {
        return Discount.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving available size product: $e');
      return null;
    }
  }

  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot productSnapshot =
          await productCollection.doc(productId).get();

      if (productSnapshot.exists) {
        Product product = Product.fromDocument(productSnapshot);
        List<String> imageUrls = await getImageUrls(productId);
        product.imageUrls = imageUrls;
        return product;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
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

  Future<SizeProduct?> getSizeProductById(String sizeProductId) async {
    try {
      DocumentSnapshot doc =
          await sizeProductCollection.doc(sizeProductId).get();

      if (doc.exists) {
        return SizeProduct.fromDocument(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving size product: $e');
      return null;
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (doc.exists) {
        return OrderModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving order: $e');
      return null;
    }
  }

  Future<PaymentMethod?> getPaymentMethodById(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('paymentmethods')
          .doc(id)
          .get();

      if (doc.exists) {
        return PaymentMethod.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving order: $e');
      return null;
    }
  }

  Future<void> updateOrder(String orderId) async {
    try {
      // Thực hiện truy vấn để tìm document có orderId tương ứng
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('orderId', isEqualTo: orderId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;

        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        // Kiểm tra nếu data không null
        if (data != null) {
          if (!data.containsKey('isCancel')) {
            await snapshot.reference.update({'isCancel': true});
          }

          await snapshot.reference.update({
            'cancelDate': DateTime.now(),
            'status': 'Đã hủy',
            'isCancel': true
          });
        } else {
          // Nếu data null
          throw Exception('Dữ liệu document không tồn tại');
        }
      } else {
        throw Exception('Không tìm thấy đơn hàng có orderId $orderId');
      }
    } catch (e) {
      // Xử lý khi có lỗi xảy ra
      throw Exception('Lỗi khi cập nhật đơn hàng: $e');
    }
  }
}
