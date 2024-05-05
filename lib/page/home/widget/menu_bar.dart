import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:provider/provider.dart';
import '../../../repositories/auth/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/customer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuBarRight extends StatelessWidget {
  void _handleLogout(BuildContext context) async {
    try {
      // Tạo một CartRepository mới
      CartRepository cartRepository = CartRepository();

      // Xóa dữ liệu giỏ hàng
      await cartRepository.clearCartItems();
      print(cartRepository.cartItems.length);

      // Cập nhật giá trị của CartRepository bằng cách thay thế value hiện tại
      Provider.of<CartRepository>(context, listen: false).value =
          cartRepository;

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Đăng xuất',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Xác nhận đăng xuất?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Đăng xuất'),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Hủy'),
                ),
              ],
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _handleLogout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Map<String, dynamic> userData =
                currentUserSnapshot.data() as Map<String, dynamic>;
            // Tạo một đối tượng Customer từ dữ liệu được lấy từ Cloud Firestore
            Customer currentUser = Customer.fromMap(userData);

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
                  UserAccountsDrawerHeader(
                    accountName: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentUser.customerName.isNotEmpty
                              ? currentUser.customerName
                              : currentUser.customerEmail,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    accountEmail: null,
                    currentAccountPicture: Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: currentUser.customerAvatar.isNotEmpty
                            ? AssetImage(currentUser.customerAvatar)
                            : AssetImage('images/avt.png'),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/geeta.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Trang cá nhân',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () =>
                        {Navigator.pushReplacementNamed(context, '/profile')},
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.shopping_bag,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Đơn hàng',
                        style: TextStyle(
                          color: Colors.black, // Màu chữ trắng
                        ),
                      ),
                      onTap: () => {
                            Navigator.pushReplacementNamed(context, '/myOrder')
                          }),
                  ListTile(
                    leading: Icon(
                      Icons.wallet_giftcard_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Khuyến mãi',
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 63, 63, 63), // Màu chữ trắng
                      ),
                    ),
                    onTap: () => null,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Request',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => null,
                  ),
                  Divider(
                    color: Colors.black45,
                  ),
                  ListTile(
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    onTap: () => _confirmLogout(context),
                  ),
                ]),
                backgroundColor: Colors.white,
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
