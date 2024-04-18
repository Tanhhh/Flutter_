import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../page/home/home.page.dart';
import 'user_repository.dart';

Future<void> loginUserWithEmailAndPassword(
    BuildContext context, String email, String password) async {
  try {
    bool isEmailValid(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isEmpty || password.isEmpty) {
      throw 'Vui lòng điền đầy đủ thông tin.';
    }

    if (!isEmailValid(email)) {
      throw 'Email không đúng định dạng.';
    }

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .where('customerEmail', isEqualTo: email)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      QuerySnapshot userWithPasswordSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('customerEmail', isEqualTo: email)
          .where('customerPassword', isEqualTo: password)
          .get();

      // Nếu tìm thấy người dùng có cả email và mật khẩu tương ứng
      if (userWithPasswordSnapshot.docs.isNotEmpty) {
        print('Đăng nhập thành công!');

        // Lưu thông tin người dùng vào UserRepository
        UserRepository().setUser(userWithPasswordSnapshot.docs.first);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Đăng nhập thành công!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text('Đóng'),
                ),
              ],
            );
          },
        );
      } else {
        throw 'Mật khẩu không đúng.';
      }
    } else {
      throw 'Người dùng không tồn tại.';
    }
  } catch (e) {
    String errorMessage = '$e';

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
