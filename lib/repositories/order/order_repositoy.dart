import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';
import '../../model/order_model.dart';

class OrderRepository {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference _orderDetailsCollection =
      FirebaseFirestore.instance.collection('orderdetails');

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
        'updatedDate': now,
        'paymentMethodId': order.paymentMethodId,
        'customerId': order.customerId,
        'userId': '',
        'discountId': order.discountId,
      };

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
        'productId': orderDetail.productId,
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
          // Chuyển đổi Timestamp thành DateTime
          createDate: (snapshot['createDate'] as Timestamp).toDate(),
          updatedDate: (snapshot['updatedDate'] as Timestamp).toDate(),
          paymentMethodId: snapshot['paymentMethodId'],
          customerId: snapshot['customerId'],
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

  Future<List<OrderModel>> getUnconfirmedOrdersByCustomerId(
      String customerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('customerId', isEqualTo: customerId)
              .where('isConfirm', isEqualTo: false)
              .get();

      List<OrderModel> orders = querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      return orders;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error getting unconfirmed orders by customer id: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }
}
