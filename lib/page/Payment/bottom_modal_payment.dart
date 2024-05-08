import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Address/provider/get_address.dart';
import 'package:flutter_ltdddoan/page/Payment/bottom_totalPrice.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_paymentmethod.dart';
import 'package:provider/provider.dart';
import '../Address/Addresses.dart';
import '../Payment/PaymentMethods.dart';
import 'package:another_flushbar/flushbar.dart';

class BottomModalPayment extends StatelessWidget {
  const BottomModalPayment({Key? key});

  @override
  Widget build(BuildContext context) {
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
                fontSize: 20, // Tăng kích thước chữ
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2, // Tăng độ dày của đường kẻ
              color: Colors.grey[400], // Màu sắc đậm hơn
            ),
            SizedBox(height: 20), // Khoảng cách giữa các phần tử
            buildOptionRowAddress('Địa chỉ giao hàng', Icons.arrow_forward_ios,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressScreen(),
                  settings: RouteSettings(name: '/address'),
                ),
              );
            },
                showSelected: Provider.of<SelectedAddressProvider>(context)
                    .hasSelectedAddress(),
                context: context),

            SizedBox(height: 20), // Khoảng cách giữa các phần tử

            buildOptionRowPayment(
                'Phương thức thanh toán', Icons.arrow_forward_ios, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentMethodsScreen(),
                  settings: RouteSettings(name: '/paymentMethod'),
                ),
              );
            },
                showSelected: Provider.of<SelectedPaymentProvider>(context)
                    .hasSelectedPayment(),
                context: context),

            SizedBox(height: 20), // Khoảng cách giữa các phần tử

            buildOptionRow(
              'Khuyến mãi',
              Icons.arrow_forward_ios,
              () {},
            ),

            Spacer(), // Đẩy nút "Tiếp tục" lên dưới cùng

            ElevatedButton(
              onPressed: () {
                bool hasSelectedAddress =
                    Provider.of<SelectedAddressProvider>(context, listen: false)
                        .hasSelectedAddress();
                bool hasSelectedPayment =
                    Provider.of<SelectedPaymentProvider>(context, listen: false)
                        .hasSelectedPayment();

                if (!hasSelectedAddress && !hasSelectedPayment) {
                  Flushbar(
                    message: "Vui lòng chọn địa chỉ và phương thức thanh toán.",
                    duration: Duration(seconds: 2),
                  )..show(context);
                } else if (!hasSelectedAddress) {
                  Flushbar(
                    message: "Vui lòng chọn địa chỉ.",
                    duration: Duration(seconds: 2),
                  )..show(context);
                } else if (!hasSelectedPayment) {
                  Flushbar(
                    message: "Vui lòng chọn phương thức thanh toán.",
                    duration: Duration(seconds: 2),
                  )..show(context);
                } else {
                  // Mở bottom modal nếu đã chọn đủ thông tin
                  Navigator.pop(context); // Đóng modal bottom hiện tại
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: BottomModalTotalPrice(),
                        ),
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6342E8),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              ),
              child: Text(
                'Tiếp tục',
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
              'Hãy nhấn tiếp tục để tiến tới bước đặt hàng',
              textAlign: TextAlign.center, // Căn giữa
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

  Widget buildOptionRowAddress(
      String title, IconData icon, VoidCallback onPressed,
      {required BuildContext context,
      bool showSelected = false,
      bool showIcon = true}) {
    final selectedAddressProvider =
        Provider.of<SelectedAddressProvider>(context);
    final bool hasSelectedAddress =
        selectedAddressProvider.hasSelectedAddress();
    String buttonText = showSelected && hasSelectedAddress
        ? selectedAddressProvider.selectedAddress!.name +
            '\n' +
            selectedAddressProvider.selectedAddress!.phone +
            '\n' +
            selectedAddressProvider.selectedAddress!.addressNote +
            ', ' +
            selectedAddressProvider.selectedAddress!.address
        : 'Chọn';
    const int MAXIMUM_TEXT_LENGTH = 60;
    if (buttonText.length > MAXIMUM_TEXT_LENGTH) {
      // Cắt nội dung và thêm dấu ba chấm ở cuối
      buttonText = buttonText.substring(0, MAXIMUM_TEXT_LENGTH - 3) + '...';
    }

    Color textColor = Colors.blue;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                if (showIcon && !showSelected)
                  Icon(
                    icon,
                    color: Colors.blue,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRowPayment(
      String title, IconData icon, VoidCallback onPressed,
      {required BuildContext context,
      bool showSelected = false,
      bool showIcon = true}) {
    final selectedPaymentProvider =
        Provider.of<SelectedPaymentProvider>(context);
    final bool hasSelectedPayment =
        selectedPaymentProvider.hasSelectedPayment();

    String buttonText = showSelected && hasSelectedPayment
        ? selectedPaymentProvider.selectedPayment!.description
        : 'Chọn';
    const int MAXIMUM_TEXT_LENGTH = 70;
    if (buttonText.length > MAXIMUM_TEXT_LENGTH) {
      // Cắt nội dung và thêm dấu ba chấm ở cuối
      buttonText = buttonText.substring(0, MAXIMUM_TEXT_LENGTH - 3) + '...';
    }

    Color textColor = Colors.blue;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                if (showIcon && !showSelected)
                  Icon(
                    icon,
                    color: Colors.blue,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionRow(String title, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8), // Tăng khoảng cách giữa các dòng
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
