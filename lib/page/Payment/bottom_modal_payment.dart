import 'package:flutter/material.dart';
import '../Payment/Purchased.dart';
import '../Address/Addresses.dart';
import '../Payment/PaymentMethods.dart';
import '../Payment/TotalPrice.dart';

class BottomModalPayment extends StatelessWidget {
  const BottomModalPayment({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            buildOptionRow(
              'Địa chỉ giao hàng',
              Icons.arrow_forward_ios,
              () {
                // Mở trang Address khi nhấn vào button chọn
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressScreen()),
                );
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            buildOptionRow(
              'Phương thức thanh toán',
              Icons.arrow_forward_ios,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentMethodsScreen()),
                );
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            buildOptionRow(
              'Khuyến mãi',
              Icons.arrow_forward_ios,
              () {
                // Xử lý khi nhấn vào button chọn khuyến mãi
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            buildOptionRow(
              'Tổng tiền',
              Icons.arrow_forward_ios,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TotalPriceScreen()),
                );
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Text(
              'Bằng cách đặt hàng, bạn đồng ý với các điều khoản sử dụng và bán hàng của Getta.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PurchasedScreen()),
                );
              },
              child: Text('Đặt hàng'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRow(String title, IconData icon, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Text(
                'Chọn',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              Icon(
                icon,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
