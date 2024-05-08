import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../page/auth/login/login.page.dart';

Future<void> registerUserWithEmailAndPassword(BuildContext context,
    String confirmpassword, String email, String password) async {
  email = email.trim();

  try {
    if (confirmpassword.isEmpty || email.isEmpty || password.isEmpty) {
      throw 'Vui lòng điền đầy đủ thông tin.';
    }

    // Kiểm tra định dạng email
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(email)) {
      throw 'Email không đúng định dạng.';
    }
    if (password != confirmpassword) {
      throw 'Mật khẩu không khớp';
    }
    if (password.length < 6) {
      throw 'Mật khẩu quá ngắn. Mật khẩu phải có ít nhất 6 ký tự.';
    }
    email = email.toLowerCase();
    // Tạo tài khoản người dùng bằng cách sử dụng FirebaseAuth
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Gửi email xác thực
    await userCredential.user?.sendEmailVerification();
    print('Email đã được gửi xác thực: ${userCredential.user?.emailVerified}');

    // Hiển thị thông báo yêu cầu kiểm tra Gmail để xác thực
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Thông báo',
              style: TextStyle(
                color: Color(0xFF6342E8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                        'Vui lòng kiểm tra Gmail để xác thực email.',
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Color(0xFF6342E8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Container(
                      height: 30,
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6342E8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      showDialog(
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
                        'Tài khoản đã tồn tại.',
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Color(0xFF6342E8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Container(
                      height: 30,
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        'Ok',
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
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
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
                        'Email không hợp lệ.',
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Color(0xFF6342E8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Container(
                      height: 30,
                      width: 90,
                      alignment: Alignment.center,
                      child: Text(
                        'Ok',
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
                ],
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Hiển thị thông báo lỗi
    showDialog(
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
                      '$e',
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                        color: Color(0xFF6342E8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    height: 30,
                    width: 90,
                    alignment: Alignment.center,
                    child: Text(
                      'Ok',
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
              ],
            ),
          ],
        );
      },
    );
  }
}
