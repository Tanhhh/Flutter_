import 'package:flutter/material.dart';
import '../Payment/Widgets/Single_Method.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:flutter_ltdddoan/repositories/payment/paymentmethod_repository.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods =
      []; // Danh sách các phương thức thanh toán
  int selectedMethodIndex = -1; // Chỉ mục của phương thức thanh toán được chọn
  PaymentMethod? selectedMethod; // Biến tạm lưu method được chọn

  @override
  void initState() {
    super.initState();
    loadPaymentMethods(); // Load danh sách các phương thức thanh toán khi màn hình được khởi tạo
  }

  // Hàm để load danh sách các phương thức thanh toán từ repository
  void loadPaymentMethods() async {
    PaymentMethodRepository repository = PaymentMethodRepository();
    paymentMethods = await repository.getPaymentMethods();
    setState(() {}); // Cập nhật lại UI sau khi load xong
  }

  // Hàm xử lý khi người dùng chọn một phương thức thanh toán
  void handleMethodSelection(int index) {
    setState(() {
      if (selectedMethodIndex == index) {
        selectedMethodIndex = -1;
        selectedMethod = null;
      } else {
        selectedMethodIndex = index;
        selectedMethod = paymentMethods[index];
      }
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
            'Phương thức thanh toán',
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
            children: paymentMethods.asMap().entries.map((entry) {
              int index = entry.key;
              PaymentMethod paymentMethod = entry.value;
              return Column(
                children: [
                  SingleMethod(
                    selectedMethod: index ==
                        selectedMethodIndex, // Đặt selectedMethod bằng true nếu đúng phương thức được chọn
                    image: Image.asset(
                        'assets/images/${paymentMethod.name.toLowerCase()}Icon.png'), // Định dạng tên ảnh dựa trên tên của phương thức
                    text: paymentMethod.description,
                    onTap: () {
                      // Xử lý khi người dùng chọn phương thức thanh toán
                      handleMethodSelection(index);
                    },
                  ),
                  Divider(),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
