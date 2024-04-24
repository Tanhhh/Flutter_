import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../page/auth/login/login.page.dart';

Future<void> registerUserWithEmailAndPassword(
    BuildContext context, String name, String email, String password) async {
  try {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw 'Vui lòng điền đầy đủ thông tin.';
    }

    // Kiểm tra định dạng email
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(email)) {
      throw 'Email không đúng định dạng.';
    }

    // Kiểm tra độ dài của mật khẩu
    if (password.length < 6) {
      throw 'Mật khẩu quá ngắn. Mật khẩu phải có ít nhất 6 ký tự.';
    }

    email = email.toLowerCase();

    // Tạo tài khoản người dùng bằng cách sử dụng FirebaseAuth
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Gửi email xác thực
    await userCredential.user?.sendEmailVerification();

    // In thông tin người dùng đã xác thực
    print('Email đã được gửi xác thực: ${userCredential.user?.emailVerified}');

    // Hiển thị thông báo yêu cầu kiểm tra Gmail để xác thực
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Vui lòng kiểm tra Gmail để xác thực email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    String errorMessage = '$e';

    // Hiển thị thông báo lỗi
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
