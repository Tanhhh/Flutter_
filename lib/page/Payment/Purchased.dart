import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/page/order_customer/order_detail.dart';
import 'package:flutter_ltdddoan/repositories/order/order_repositoy.dart';

class PurchasedScreen extends StatefulWidget {
  const PurchasedScreen({Key? key}) : super(key: key);

  @override
  _PurchasedScreenState createState() => _PurchasedScreenState();
}

class _PurchasedScreenState extends State<PurchasedScreen> {
  @override
  Widget build(BuildContext context) {
    final leadingWidth = MediaQuery.of(context).size.width / 3;
    final iconWidth = 24.0; // Kích thước của icon
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // Màu nền trong suốt
        leadingWidth: leadingWidth,
        leading: Row(
          children: [
            SizedBox(width: iconWidth), // Đảm bảo không gian cho icon
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/check.png',
                width: 200, // Chiều rộng của hình ảnh
                height: 200, // Chiều cao của hình ảnh
              ),
              SizedBox(height: 20),
              Text(
                'Đơn hàng đã đặt thành công!',
                style: TextStyle(
                  fontSize: 24, // Kích thước của văn bản
                  fontWeight: FontWeight.bold, // Độ đậm của văn bản
                ),
              ),
              Spacer(),
              Text(
                'Đơn hàng của bạn sẽ sớm được gửi',
                style: TextStyle(
                  fontSize: 14, // Kích thước của văn bản
                ),
              ),
              Text(
                'đến tay bạn nhanh nhất',
                style: TextStyle(
                  fontSize: 14, // Kích thước của văn bản
                ),
              ),
              Spacer(), // Thêm một khoảng cách linh hoạt giữa các widget
              ElevatedButton(
                onPressed: () async {
                  OrderRepository orderRepo = OrderRepository();
                  OrderModel? latestOrder = await orderRepo.getLatestOrder();
                  if (latestOrder != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          orderId: latestOrder.orderId!,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Xem đơn hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Màu văn bản là màu trắng
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6342e8), // Màu nền của nút
                  minimumSize: Size(
                      double.infinity, 50.0), // Kích thước tối thiểu của nút
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Tiếp tục mua sắm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Màu văn bản là màu trắng
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6342e8), // Màu nền của nút
                  minimumSize: Size(
                      double.infinity, 50.0), // Kích thước tối thiểu của nút
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
