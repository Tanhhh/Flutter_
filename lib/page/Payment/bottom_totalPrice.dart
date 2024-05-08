import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/cart_model.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';
import 'package:flutter_ltdddoan/page/Address/provider/get_address.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/Payment/Purchased.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_paymentmethod.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_totalprice.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:flutter_ltdddoan/repositories/order/order_repositoy.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BottomModalTotalPrice extends StatelessWidget {
  const BottomModalTotalPrice({Key? key});

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    final selectedPaymentProvider =
        Provider.of<SelectedPaymentProvider>(context);
    final cart = Provider.of<CartRepository>(context);
    double totalPrice = cart.getTotalPrice();
    final selectedAddressProvider =
        Provider.of<SelectedAddressProvider>(context);
    double ship = 0;

    ship = cart.calculateShippingFee(
        selectedAddressProvider.selectedAddress?.address ?? '');
    double discount = 0;
    double totalpricefinal = totalPrice + ship - discount;

    // Cập nhật giá trị tổng tiền vào TotalPriceProvider
    Provider.of<TotalPriceProvider>(context, listen: false)
        .setTotalPrice(totalpricefinal);

    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            buildPriceItem(
              'Tổng tiền ban đầu',
              '${currencyFormat.format(totalPrice)} VND',
            ),
            buildPriceItem(
              'Phí vận chuyển',
              '+ ${currencyFormat.format(ship)} VND',
            ),
            buildPriceItem(
              'Khuyến mãi',
              '- ${currencyFormat.format(discount)} VND',
            ),
            Divider(),
            TotalPrice(
              'Tổng tiền',
              '${currencyFormat.format(totalpricefinal)} VND',
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                try {
                  OrderRepository orderRepo = OrderRepository();

                  User? currentUser = UserRepository().getUserAuth();
                  if (selectedPaymentProvider.selectedPayment?.name != 'cod') {
                    OrderModel order = OrderModel(
                        paymentMethodId: selectedPaymentProvider
                            .selectedPayment!.paymentMethodId,
                        totalPayment: totalpricefinal,
                        customerId: currentUser!.uid,
                        isPay: true);
                    await orderRepo.addOrder(order);
                  } else {
                    OrderModel order = OrderModel(
                        paymentMethodId: selectedPaymentProvider
                            .selectedPayment!.paymentMethodId,
                        totalPayment: totalpricefinal,
                        customerId: currentUser!.uid,
                        isPay: false);
                    await orderRepo.addOrder(order);
                  }

                  OrderModel? latestOrder = await orderRepo.getLatestOrder();

                  for (Cart item in cart.selectedItems) {
                    String productId =
                        await cart.getProductIdByName(item.productName);
                    if (latestOrder != null) {
                      String latestOrderId = latestOrder.orderId!;
                      OrderDetail orderDetail = OrderDetail(
                        orderId: latestOrderId,
                        productId: productId,
                        price: item.price,
                        quantity: item.quantity,
                      );

                      await orderRepo.addOrderDetail(orderDetail);
                    }
                  }

                  Navigator.pushReplacementNamed(context, '/success');
                } catch (e) {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6342E8),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              ),
              child: Text(
                'Đặt hàng',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              'Bằng cách đặt hàng, bạn đồng ý với các điều khoản sử dụng và bán hàng của Getta.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
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
            fontSize: 16,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 16,
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
