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
  PaymentMethodRepository repository = PaymentMethodRepository();
  String? img;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPaymentMethods();
  }

  void loadPaymentMethods() async {
    // Load danh sách các phương thức thanh toán khi màn hình được khởi tạo
    paymentMethods = await repository.getPaymentMethods();
    if (Provider.of<SelectedPaymentProvider>(context, listen: false)
        .hasSelectedPayment()) {
      selectedMethod =
          Provider.of<SelectedPaymentProvider>(context, listen: false)
              .selectedPayment;
      selectedMethodIndex = paymentMethods
          .indexWhere((element) => element.name == selectedMethod!.name);
    }

    setState(() {
      _isLoading = false; // Kết thúc quá trình tải
    });
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
    final iconWidth = 24.0;

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
              label: SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            'Phương thức thanh toán',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Hiển thị biểu tượng loading
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: paymentMethods.map((paymentMethod) {
                    int index = paymentMethods.indexOf(paymentMethod);
                    return FutureBuilder<String?>(
                      future: repository
                          .getImageUrl(paymentMethod.paymentMethodId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          img = snapshot.data;
                          return GestureDetector(
                            onTap: () {
                              handleMethodSelection(index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: selectedMethodIndex == index
                                    ? Colors.green.withOpacity(0.3)
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedMethodIndex == index
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        img ?? '',
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
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
