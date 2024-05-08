import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_paymentmethod.dart';
import 'package:provider/provider.dart';
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
  int? selectedMethodIndex;
  PaymentMethod? selectedMethod; // Biến tạm lưu method được chọn

  @override
  void initState() {
    super.initState();
    loadPaymentMethods(); // Load danh sách các phương thức thanh toán khi màn hình được khởi tạo
  }

  void loadPaymentMethods() async {
    PaymentMethodRepository repository = PaymentMethodRepository();
    paymentMethods = await repository.getPaymentMethods();

    if (Provider.of<SelectedPaymentProvider>(context, listen: false)
        .hasSelectedPayment()) {
      selectedMethod =
          Provider.of<SelectedPaymentProvider>(context, listen: false)
              .selectedPayment;
      selectedMethodIndex = paymentMethods
          .indexWhere((element) => element.name == selectedMethod!.name);
    }

    setState(() {});
  }

  void handleMethodSelection(int index) {
    setState(() {
      if (selectedMethodIndex == index) {
        selectedMethodIndex = null;
        selectedMethod = null;
        Provider.of<SelectedPaymentProvider>(context, listen: false)
            .setSelectedPayment(selectedMethod!);
      } else {
        selectedMethodIndex = index;
        selectedMethod = paymentMethods[index];
        Provider.of<SelectedPaymentProvider>(context, listen: false)
            .setSelectedPayment(selectedMethod!);
        Navigator.of(context).pop();
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
        backgroundColor: Colors.transparent,
        leadingWidth: leadingWidth,
        leading: Row(
          children: [
            SizedBox(width: iconWidth),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
            children: paymentMethods.map((paymentMethod) {
              int index = paymentMethods.indexOf(paymentMethod);
              return GestureDetector(
                onTap: () {
                  handleMethodSelection(index);
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedMethodIndex == index
                        ? Colors.grey.withOpacity(0.3)
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedMethodIndex == index
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/${paymentMethod.name.toLowerCase()}Icon.png',
                            width: 48,
                            height: 48,
                          ),
                          SizedBox(width: 16),
                          Text(
                            paymentMethod.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (selectedMethodIndex == index)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
