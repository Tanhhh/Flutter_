import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Payment/bottom_modal_payment.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');

    return Consumer<CartRepository>(
      builder: (context, cartRepository, _) {
        double totalPrice = cartRepository.getTotalPrice();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "",
                    style: TextStyle(
                        color: Color(0xFF6342E8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${currencyFormat.format(totalPrice)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'VND',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                width: 600,
                decoration: BoxDecoration(
                  color: Color(0xFF6342E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    if (cartRepository.cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chưa có sản phẩm trong giỏ hàng!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    if (cartRepository.selectedItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chưa chọn sản phẩm để thanh toán!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: BottomModalPayment(),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: Text(
                          "Thanh toán",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
