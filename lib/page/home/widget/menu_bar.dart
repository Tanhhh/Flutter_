import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Address/provider/get_address.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_paymentmethod.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:provider/provider.dart';

import '../../customer/components/profile_menu.dart';
import '../../customer/components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void _handleLogout(BuildContext context) async {
      try {
        Provider.of<CartRepository>(context, listen: false).clearCartItems();
        Provider.of<SelectedPaymentProvider>(context, listen: false)
            .resetSelectedPayment();
        Provider.of<SelectedAddressProvider>(context, listen: false)
            .resetSelectedAddress();

        // Xóa thông tin xác thực người dùng
        UserRepository().clearUserAuth();

        // Đóng các màn hình hiện tại và chuyển hướng đến màn hình đăng nhập
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        print('Error logging out: $e');
        String errorMessage = 'Đã xảy ra lỗi khi đăng xuất';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Đóng'),
                ),
              ],
            );
          },
        );
      }
    }

    void _confirmLogout(BuildContext context) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.white,
            content: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Bạn có chắc chắn muốn xóa sản phẩm này?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Color(0xFF6342E8), // Màu viền
                          width: 1, // Độ rộng của viền
                        ),
                      ),
                    ),
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6342E8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF6342E8)),
                    ),
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _handleLogout(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    // Lấy thông tin người dùng từ auth
    User? currentUser = UserRepository().getUserAuth();

    return FutureBuilder<DocumentSnapshot?>(
      future: UserRepository().getUserCloud(currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Đang đợi dữ liệu
          return CircularProgressIndicator(); // hoặc một widget loading khác
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          // Xử lý dữ liệu khi đã có
          DocumentSnapshot? currentUserSnapshot = snapshot.data;
          if (currentUserSnapshot != null && currentUserSnapshot.exists) {
            // Lấy dữ liệu từ snapshot

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Menu",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const ProfilePic(),
                    const SizedBox(height: 20),
                    ProfileMenu(
                      text: "Tài khoản",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        {Navigator.pushReplacementNamed(context, '/profile')},
                      },
                    ),
                    ProfileMenu(
                      text: "Đơn hàng",
                      icon: "assets/icons/Bill Icon.svg",
                      press: () {
                        Navigator.pushReplacementNamed(context, '/myOrder');
                      },
                    ),
                    ProfileMenu(
                      text: "Đăng xuất",
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        _confirmLogout(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Drawer(
                child: Center(
                  child: Text(
                    'Không có thông tin người dùng',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
