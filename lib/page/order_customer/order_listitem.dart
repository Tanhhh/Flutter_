import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            buildOrderList(status: 'Mới'),
            buildOrderList(status: 'Hoàn thành'),
            buildOrderList(status: 'Đã giao'),
            buildOrderList(status: 'Hủy đơn'),
            buildOrderList(status: 'Trả hàng'),
          ],
        ),
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
                        'Order #${index + 1}',
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
