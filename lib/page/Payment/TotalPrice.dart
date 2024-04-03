import 'package:flutter/material.dart';

class TotalPriceScreen extends StatefulWidget {
  const TotalPriceScreen({Key? key}) : super(key: key);

  @override
  _TotalPriceScreenState createState() => _TotalPriceScreenState();
}

class _TotalPriceScreenState extends State<TotalPriceScreen> {

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
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              label: SizedBox.shrink(), // Ẩn chữ
              style: ElevatedButton.styleFrom(
                elevation: 0, // Không hiển thị shadow
                backgroundColor: Colors.transparent, // Màu nền trong suốt
                foregroundColor: Colors.black, // Màu chữ
              ),
            ),
          ],
        ),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true, // Canh giữa tiêu đề văn bản
          title: Text(
            'Tổng tiền',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPriceItem('Tổng tiền ban đầu', '2.170.000 VNĐ'),
            buildPriceItem('Phí vận chuyển', '+30.000 VNĐ'),
            buildPriceItem('Khuyến mãi', '-200.000 VNĐ'),
            Divider(),
            TotalPrice('Tổng tiền', '2.000.000 VN'),
          ],
        ),
      ),
    );
  }
  Widget buildPriceItem(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  Widget TotalPrice(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}
