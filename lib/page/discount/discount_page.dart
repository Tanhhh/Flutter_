import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/discount/provider/get_discount.dart';
import 'package:flutter_ltdddoan/repositories/discount/discount_repositoy.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PromotionListPage extends StatefulWidget {
  const PromotionListPage({Key? key}) : super(key: key);

  @override
  _PromotionListPageState createState() => _PromotionListPageState();
}

class _PromotionListPageState extends State<PromotionListPage> {
  List<Discount> discount = [];
  int? selectedDiscountIndex;
  Discount? selectedDiscount;

  @override
  void initState() {
    super.initState();
    loadPaymentMethods();
  }

  void loadPaymentMethods() async {
    DiscountRepository repository = DiscountRepository();
    discount = await repository.getActiveDiscounts();

    if (Provider.of<SelectedDiscountProvider>(context, listen: false)
        .hasSelectedDiscount()) {
      selectedDiscount =
          Provider.of<SelectedDiscountProvider>(context, listen: false)
              .selectedDiscount;
      selectedDiscountIndex = discount
          .indexWhere((element) => element.name == selectedDiscount!.name);
    }

    setState(() {});
  }

  void handleMethodSelection(int index) {
    setState(() {
      if (selectedDiscountIndex == index) {
        selectedDiscountIndex = null;
        selectedDiscount = null;
        Provider.of<SelectedDiscountProvider>(context, listen: false)
            .setSelectedDiscount(selectedDiscount!);
      } else {
        selectedDiscountIndex = index;
        selectedDiscount = discount[index];
        Provider.of<SelectedDiscountProvider>(context, listen: false)
            .setSelectedDiscount(selectedDiscount!);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartRepository>(context);
    double totalPrice = cart.getTotalPrice();
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
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
            'Khuyến mãi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 24, vertical: 12), // padding
          child: Column(
            children: discount.map((paymentMethod) {
              int index = discount.indexOf(paymentMethod);
              return GestureDetector(
                onTap: () {
                  if (totalPrice >= paymentMethod.price) {
                    handleMethodSelection(index);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Tổng giá trị đơn hàng phải lớn hơn hoặc bằng giá trị áp dụng của khuyến mãi.'),
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: 12), // Khoảng cách giữa các item
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: totalPrice < paymentMethod.price
                        ? Colors.grey
                            .withOpacity(0.3) // Màu xám khi totalPrice < price
                        : selectedDiscountIndex == index
                            ? Colors.green.withOpacity(0.3)
                            : null,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedDiscountIndex == index
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
                            'assets/images/sale.png',
                            width: 70,
                            height: 70,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paymentMethod.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                paymentMethod.description,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Áp dụng với hóa đơn từ ${currencyFormat.format(paymentMethod.price)}VND trở lên',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (selectedDiscountIndex == index)
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
