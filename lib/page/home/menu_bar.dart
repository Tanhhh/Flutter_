import 'package:flutter/material.dart';
import '../customer/profile.dart';
import '../order_customer/order_listitem.dart';

class MenuBarRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Lê Tuấn Anh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('letuananh4282@gmail.com'),
              currentAccountPicture: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.asset('images/avt.jpg'),
                  ),
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
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                )
              },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrderScreen()),
                      )
                    }),
            ListTile(
              leading: Icon(
                Icons.wallet_giftcard_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Khuyến mãi',
                style: TextStyle(
                  color: const Color.fromARGB(255, 63, 63, 63), // Màu chữ trắng
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
                  color: Colors.black, // Màu chữ trắng
                ),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black, // Màu chữ trắng
              ),
              onTap: () => null,
            ),
          ],
        ),
        // Đặt màu nền cho phần dưới cùng của Drawer
        backgroundColor: Colors.white,
      ),
    );
  }
}
