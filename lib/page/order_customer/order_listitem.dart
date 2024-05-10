import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/page/order_customer/order_detail.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:flutter_ltdddoan/repositories/order/order_repositoy.dart';
import 'package:intl/intl.dart';

class MyOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser;
    currentUser = UserRepository().getUserAuth();
    return DefaultTabController(
      length: 6, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đơn mua', style: TextStyle(fontWeight: FontWeight.w700)),
          centerTitle: true,
          backgroundColor: Colors.white30,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Mới'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Hủy đơn'),
              Tab(text: 'Trả hàng'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildOrderListNew(id: currentUser!.uid),
            buildOrderListSuccess(id: currentUser.uid),
            buildOrderListCancel(id: currentUser.uid),
            buildOrderListReturn(id: currentUser.uid),
          ],
        ),
      ),
    );
  }

  Widget buildOrderListNew({required String id}) {
    OrderRepository orderRepo = OrderRepository();
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return Container(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<OrderModel>>(
        future: orderRepo.getUnconfirmedOrdersByCustomerId(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<OrderModel> orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    'Chưa có đơn hàng',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }
              DateTime _getLastUpdateTime(OrderModel order) {
                // Sử dụng hàm max để lấy thời gian lớn nhất từ danh sách các thời gian
                return [
                  order.successDate,
                  order.cancelDate,
                  order.returnDate,
                  order.shipDate,
                  order.confirmDate,
                  order.createDate,
                ].where((date) => date != null).fold(DateTime(0),
                    (prev, curr) => curr!.isAfter(prev) ? curr : prev);
              }

              orders.sort((a, b) {
                // Lấy thời gian cuối cùng mà đơn hàng được cập nhật (hoặc tạo nếu chưa có)
                DateTime lastUpdateTimeA = _getLastUpdateTime(a);
                DateTime lastUpdateTimeB = _getLastUpdateTime(b);

                // So sánh thời gian cuối cùng
                return lastUpdateTimeB.compareTo(lastUpdateTimeA);
              });

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: orders[index].orderId!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${orders[index].orderId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6342E8),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  '${orders[index].createDate?.hour.toString().padLeft(2, '0') ?? ''}:'
                                  '${orders[index].createDate?.minute.toString().padLeft(2, '0') ?? ''} '
                                  '${orders[index].createDate?.day}/${orders[index].createDate?.month}/${orders[index].createDate?.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currencyFormat.format(orders[index].totalPayment)}VND',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    // Xử lý khi nhấn vào trạng thái đơn hàng
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: orders[index].status ==
                                              'Hoàn thành'
                                          ? Colors.green[900]
                                          : orders[index].status ==
                                                  'Chờ xác nhận'
                                              ? Colors.purple[200]
                                              : orders[index].status ==
                                                      'Chờ vận chuyển'
                                                  ? Colors.yellow[900]
                                                  : orders[index].status ==
                                                          'Đang vận chuyển'
                                                      ? Colors.blue[900]
                                                      : orders[index].status ==
                                                              'Đã hủy'
                                                          ? Colors.red[900]
                                                          : orders[index]
                                                                      .status ==
                                                                  'Trả hàng'
                                                              ? Colors
                                                                  .orange[900]
                                                              : Colors.black,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${orders[index].status}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget buildOrderListSuccess({required String id}) {
    OrderRepository orderRepo = OrderRepository();
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return Container(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<OrderModel>>(
        future: orderRepo.getSuccessOrdersByCustomerId(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<OrderModel> orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    'Chưa có đơn hàng hoàn thành',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }
              DateTime _getLastUpdateTime(OrderModel order) {
                return [
                  order.successDate,
                  order.cancelDate,
                  order.returnDate,
                  order.shipDate,
                  order.confirmDate,
                  order.createDate,
                ].where((date) => date != null).fold(DateTime(0),
                    (prev, curr) => curr!.isAfter(prev) ? curr : prev);
              }

              orders.sort((a, b) {
                // Lấy thời gian cuối cùng mà đơn hàng được cập nhật (hoặc tạo nếu chưa có)
                DateTime lastUpdateTimeA = _getLastUpdateTime(a);
                DateTime lastUpdateTimeB = _getLastUpdateTime(b);

                return lastUpdateTimeB.compareTo(lastUpdateTimeA);
              });

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: orders[index].orderId!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${orders[index].orderId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6342E8),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  '${orders[index].successDate?.hour.toString().padLeft(2, '0') ?? ''}:'
                                  '${orders[index].successDate?.minute.toString().padLeft(2, '0') ?? ''} '
                                  '${orders[index].successDate?.day}/${orders[index].successDate?.month}/${orders[index].successDate?.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currencyFormat.format(orders[index].totalPayment)}VND',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    // Xử lý khi nhấn vào trạng thái đơn hàng
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green[900]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${orders[index].status}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget buildOrderListCancel({required String id}) {
    OrderRepository orderRepo = OrderRepository();
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return Container(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<OrderModel>>(
        future: orderRepo.getCancelOrdersByCustomerId(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<OrderModel> orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    'Chưa có đơn hàng hủy',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }
              DateTime _getLastUpdateTime(OrderModel order) {
                // Sử dụng hàm max để lấy thời gian lớn nhất từ danh sách các thời gian
                return [
                  order.successDate,
                  order.cancelDate,
                  order.returnDate,
                  order.shipDate,
                  order.confirmDate,
                  order.createDate,
                ].where((date) => date != null).fold(DateTime(0),
                    (prev, curr) => curr!.isAfter(prev) ? curr : prev);
              }

              orders.sort((a, b) {
                // Lấy thời gian cuối cùng mà đơn hàng được cập nhật (hoặc tạo nếu chưa có)
                DateTime lastUpdateTimeA = _getLastUpdateTime(a);
                DateTime lastUpdateTimeB = _getLastUpdateTime(b);

                // So sánh thời gian cuối cùng
                return lastUpdateTimeB.compareTo(lastUpdateTimeA);
              });
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: orders[index].orderId!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${orders[index].orderId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6342E8),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  '${orders[index].cancelDate?.hour.toString().padLeft(2, '0') ?? ''}:'
                                  '${orders[index].cancelDate?.minute.toString().padLeft(2, '0') ?? ''} '
                                  '${orders[index].cancelDate?.day}/${orders[index].cancelDate?.month}/${orders[index].cancelDate?.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currencyFormat.format(orders[index].totalPayment)}VND',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    // Xử lý khi nhấn vào trạng thái đơn hàng
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red[900]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${orders[index].status}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget buildOrderListReturn({required String id}) {
    OrderRepository orderRepo = OrderRepository();
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return Container(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<OrderModel>>(
        future: orderRepo.getReturnOrdersByCustomerId(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<OrderModel> orders = snapshot.data ?? [];

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    'Chưa có đơn hàng hoàn trả',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }
              DateTime _getLastUpdateTime(OrderModel order) {
                // Sử dụng hàm max để lấy thời gian lớn nhất từ danh sách các thời gian
                return [
                  order.successDate,
                  order.cancelDate,
                  order.returnDate,
                  order.shipDate,
                  order.confirmDate,
                  order.createDate,
                ].where((date) => date != null).fold(DateTime(0),
                    (prev, curr) => curr!.isAfter(prev) ? curr : prev);
              }

              orders.sort((a, b) {
                // Lấy thời gian cuối cùng mà đơn hàng được cập nhật (hoặc tạo nếu chưa có)
                DateTime lastUpdateTimeA = _getLastUpdateTime(a);
                DateTime lastUpdateTimeB = _getLastUpdateTime(b);

                // So sánh thời gian cuối cùng
                return lastUpdateTimeB.compareTo(lastUpdateTimeA);
              });
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: orders[index].orderId!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${orders[index].orderId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6342E8),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  '${orders[index].returnDate?.hour.toString().padLeft(2, '0') ?? ''}:'
                                  '${orders[index].returnDate?.minute.toString().padLeft(2, '0') ?? ''} '
                                  '${orders[index].returnDate?.day}/${orders[index].returnDate?.month}/${orders[index].returnDate?.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${currencyFormat.format(orders[index].totalPayment)}VND',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    // Xử lý khi nhấn vào trạng thái đơn hàng
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.orange[900]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${orders[index].status}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

String formatDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${date.day}/${date.month}/${date.year}';
}
