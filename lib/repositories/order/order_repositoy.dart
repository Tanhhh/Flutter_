import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';

import '../../model/order_model.dart';

class OrderRepository {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference _orderDetailsCollection =
      FirebaseFirestore.instance.collection('orderdetails');
  final CollectionReference availableSizeProductCollection =
      FirebaseFirestore.instance.collection('availablesizeproduct');
  final CollectionReference sizeProductCollection =
      FirebaseFirestore.instance.collection('sizeproduct');
  Future<void> addOrder(OrderModel order) async {
    try {
      final now = DateTime.now();
      final Map<String, dynamic> orderData = {
        'orderId': '',
        'note': '',
        'isSuccess': false,
        'isCancel': false,
        'isReturn': false,
        'isPay': order.isPay,
        'isConfirm': false,
        'isShip': false,
        'status': 'Chờ xác nhận',
        'totalPayment': order.totalPayment,
        'createDate': now,
        'paymentMethodId': order.paymentMethodId,
        'customerAddressId': order.customerAddressId,
        'userId': '',
        'discountId': order.discountId,
      };

      if (order.discountId != null) {
        await updateDiscountQuantity(order.discountId);
      }

      DocumentReference docRef = await _ordersCollection.add(orderData);
      String newOrderId = docRef.id;
      await docRef.update({'orderId': newOrderId});
    } catch (e) {
      throw Exception("Failed to add order: $e");
    }
  }

  Future<void> addOrderDetail(OrderDetail orderDetail) async {
    try {
      final Map<String, dynamic> orderData = {
        'orderId': orderDetail.orderId,
        'availableSizeProductId': orderDetail.productId,
        'price': orderDetail.price,
        'quantity': orderDetail.quantity,
      };
      await _orderDetailsCollection.add(orderData);
    } catch (e) {
      throw Exception("Failed to add order detail: $e");
    }
  }

  Future<OrderModel?> getLatestOrder() async {
    try {
      // Lấy danh sách tất cả các order theo thời gian tạo
      QuerySnapshot querySnapshot = await _ordersCollection
          .orderBy('createDate', descending: true)
          .limit(1)
          .get();

      // Kiểm tra xem có order nào không
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy thông tin của order đầu tiên trong danh sách (order mới nhất)
        DocumentSnapshot snapshot = querySnapshot.docs.first;

        // Chuyển đổi dữ liệu từ snapshot thành OrderModel
        OrderModel order = OrderModel(
          orderId: snapshot['orderId'],
          note: snapshot['note'],
          isSuccess: snapshot['isSuccess'],
          isCancel: snapshot['isCancel'],
          isReturn: snapshot['isReturn'],
          isPay: snapshot['isPay'],
          isConfirm: snapshot['isConfirm'],
          isShip: snapshot['isShip'],
          status: snapshot['status'],
          totalPayment: snapshot['totalPayment'],
          createDate: (snapshot['createDate'] as Timestamp).toDate(),
          paymentMethodId: snapshot['paymentMethodId'],
          customerAddressId: snapshot['customerAddressId'],
          userId: snapshot['userId'],
          discountId: snapshot['discountId'],
        );

        return order;
      } else {
        // Nếu không có order nào, trả về null
        return null;
      }
    } catch (e) {
      // Xử lý khi có lỗi xảy ra
      throw Exception("Failed to get latest order: $e");
    }
  }

  Future<List<CustomerAddress>> getCustomerAddressesByCustomerId(
      String customerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('customeraddress')
              .where('customerId', isEqualTo: customerId)
              .get();

      List<CustomerAddress> customerAddresses = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return CustomerAddress(
          customerAddressId: doc.id,
          name: data['name'],
          phone: data['phone'],
          address: data['address'],
          addressNote: data['addressNote'],
          createDate: (data['createDate'] as Timestamp).toDate(),
          updatedDate: (data['updatedDate'] as Timestamp).toDate(),
          customerId: data['customerId'],
        );
      }).toList();

      return customerAddresses;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting customer addresses by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<OrderModel>> getUnconfirmedOrdersByCustomerId(
      String customerId) async {
    try {
      // Lấy danh sách địa chỉ của khách hàng
      List<CustomerAddress> customerAddresses =
          await getCustomerAddressesByCustomerId(customerId);

      List<OrderModel> unconfirmedOrders = [];

      for (var address in customerAddresses) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('orders')
                .where('customerAddressId',
                    isEqualTo: address.customerAddressId)
                .get();

        // Thêm các đơn hàng chưa xác nhận vào danh sách
        unconfirmedOrders.addAll(querySnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .where((element) =>
                element.isCancel == false &&
                element.isReturn == false &&
                element.isSuccess == false)
            .toList());
      }

      return unconfirmedOrders;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting unconfirmed orders by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<OrderModel>> getSuccessOrdersByCustomerId(
      String customerId) async {
    try {
      // Lấy danh sách địa chỉ của khách hàng
      List<CustomerAddress> customerAddresses =
          await getCustomerAddressesByCustomerId(customerId);

      // Tạo danh sách để lưu các đơn hàng chưa xác nhận
      List<OrderModel> unconfirmedOrders = [];

      for (var address in customerAddresses) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('orders')
                .where('customerAddressId',
                    isEqualTo: address.customerAddressId)
                .get();

        unconfirmedOrders.addAll(querySnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .where((element) => element.isSuccess == true)
            .toList());
      }

      return unconfirmedOrders;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting unconfirmed orders by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<OrderModel>> getCancelOrdersByCustomerId(
      String customerId) async {
    try {
      // Lấy danh sách địa chỉ của khách hàng
      List<CustomerAddress> customerAddresses =
          await getCustomerAddressesByCustomerId(customerId);

      // Tạo danh sách để lưu các đơn hàng chưa xác nhận
      List<OrderModel> unconfirmedOrders = [];

      // Duyệt qua từng địa chỉ của khách hàng để tìm các đơn hàng chưa xác nhận
      for (var address in customerAddresses) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('orders')
                .where('customerAddressId',
                    isEqualTo: address.customerAddressId)
                .get();

        unconfirmedOrders.addAll(querySnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .where((element) => element.isCancel == true)
            .toList());
      }

      return unconfirmedOrders;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting unconfirmed orders by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<List<OrderModel>> getReturnOrdersByCustomerId(
      String customerId) async {
    try {
      // Lấy danh sách địa chỉ của khách hàng
      List<CustomerAddress> customerAddresses =
          await getCustomerAddressesByCustomerId(customerId);

      // Tạo danh sách để lưu các đơn hàng chưa xác nhận
      List<OrderModel> unconfirmedOrders = [];

      // Duyệt qua từng địa chỉ của khách hàng để tìm các đơn hàng chưa xác nhận
      for (var address in customerAddresses) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('orders')
                .where('customerAddressId',
                    isEqualTo: address.customerAddressId)
                .get();

        unconfirmedOrders.addAll(querySnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .where((element) => element.isReturn == true)
            .toList());
      }

      return unconfirmedOrders;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting unconfirmed orders by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<void> updateDiscountQuantity(String? discountId) async {
    try {
      // Lấy thông tin discount từ Firestore
      DocumentSnapshot discountSnapshot = await FirebaseFirestore.instance
          .collection('discount')
          .doc(discountId)
          .get();

      // Kiểm tra xem tài liệu discount có tồn tại không
      if (discountSnapshot.exists) {
        // Ép kiểu dữ liệu của dữ liệu trả về về dạng Map<String, dynamic>
        Map<String, dynamic> discountData =
            discountSnapshot.data() as Map<String, dynamic>;

        // Lấy giá trị hiện tại của trường "quantity"
        int currentQuantity = discountData['quantity'];

        // Nếu quantity > 0, giảm quantity đi một đơn vị
        if (currentQuantity > 0) {
          int newQuantity = currentQuantity - 1;

          // Cập nhật trường "quantity" mới
          await FirebaseFirestore.instance
              .collection('discount')
              .doc(discountId)
              .update({'quantity': newQuantity});

          // Nếu quantity sau khi giảm bằng 0, đặt trường "isActive" thành false
          if (newQuantity == 0) {
            await FirebaseFirestore.instance
                .collection('discount')
                .doc(discountId)
                .update({'isActive': false});
          }

          print('Discount quantity updated successfully');
        } else {
          print('Quantity is already 0');
        }
      } else {
        print('Discount document does not exist');
      }
    } catch (e) {
      print('Error updating discount quantity: $e');
    }
  }

  Future<String?> findSizeProductIdBySizeName(String sizeName) async {
    QuerySnapshot querySnapshot = await sizeProductCollection
        .where('name', isEqualTo: sizeName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['sizeProductId'];
    } else {
      return null;
    }
  }

  Future<List<String>> findAvailableSizeProductIds(
      String productId, String sizeProductId) async {
    QuerySnapshot querySnapshot = await availableSizeProductCollection
        .where('productId', isEqualTo: productId)
        .where('sizeProductId', isEqualTo: sizeProductId)
        .get();

    List<String> ids = [];
    if (querySnapshot.docs.isNotEmpty) {
      ids = querySnapshot.docs.map((doc) => doc.id).toList();
    }
    return ids;
  }
}
