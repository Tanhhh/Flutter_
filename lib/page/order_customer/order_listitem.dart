import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
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
          title: Text('Đơn mua'),
          centerTitle: true,
          backgroundColor: Colors.white30,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color(0xFF4C54A5),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
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
            buildOrderList(status: 'Hoàn thành'),
            buildOrderList(status: 'Đã giao'),
            buildOrderList(status: 'Hủy đơn'),
            buildOrderList(status: 'Trả hàng'),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Xử lý khi nhấn vào một đơn hàng
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
                                    width: 120,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: orders[index].status == 'completed'
                                          ? Colors.green[900]
                                          : orders[index].status ==
                                                  'Chờ xác nhận'
                                              ? Colors.purple[200]
                                              : Colors.red[900],
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

  Widget buildOrderList({required String status}) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: 5, // Số lượng đơn hàng mẫu
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Xử lý khi nhấn vào một đơn hàng
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đơn hàng #${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date: 01/04/2024',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total: \$100',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward) // Icon cho mỗi đơn hàng
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${date.day}/${date.month}/${date.year}';
}
