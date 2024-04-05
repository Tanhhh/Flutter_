import 'package:flutter/material.dart';
import '../Payment/Widgets/Single_Method.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool isSelectedMethod1 = false;
  bool isSelectedMethod2 = false;

  void selectMethod1() {
    setState(() {
      isSelectedMethod1 = true;
      isSelectedMethod2 = false;
    });
  }

  void selectMethod2() {
    setState(() {
      isSelectedMethod1 = false;
      isSelectedMethod2 = true;
    });
  }

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
            'Địa chỉ của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24), //padding
          child: Column(
            children: [
              SingleMethod(
                selectedMethod: isSelectedMethod1,
                image: Image.asset('assets/images/momoicon.png'),
                text: 'Ví điện tử Momo',
                onTap: selectMethod1,
              ),
              Divider(),
              SizedBox(height: 20),
              SingleMethod(
                selectedMethod: isSelectedMethod2,
                image: Image.asset('assets/images/codIcon.png'),
                text: 'Thanh toán khi nhận hàng',
                onTap: selectMethod2,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
