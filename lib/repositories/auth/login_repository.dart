import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:provider/provider.dart';
import '../../page/home/home.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/customer_model.dart';
import '../auth/user_repository.dart';

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

    // Chuyển đổi email thành chữ thường trước khi tìm kiếm
    email = email.toLowerCase();

    // Thực hiện đăng nhập bằng email và mật khẩu
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    String userUID = userCredential.user!.uid;

    print('Xác thực: ${userCredential.user?.emailVerified}');
    // Kiểm tra xem email đã được xác thực chưa
    if (!userCredential.user!.emailVerified) {
      throw 'Email của bạn chưa được xác thực.';
    }

    // Lưu thông tin người dùng vào biến currentUserAuth
    User? user = userCredential.user;
    UserRepository().setUserAuth(user);

    // Kiểm tra xem userUID có tồn tại trong collection 'customers' không
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(userUID)
        .get();

    // Nếu tài liệu tồn tại và customerId trùng với userUID, đăng nhập thành công
    if (userSnapshot.exists &&
        (userSnapshot.data() as Map<String, dynamic>)['customerId'] ==
            userUID) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/home');
          });

          return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        },
      );
    } else {
      // Nếu không tồn tại hoặc customerId không trùng với userUID, tạo mới thông tin khách hàng
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('customers').doc(userUID);

      // Tạo đối tượng Customer từ thông tin đăng ký và gán document ID vào trường customerId
      Customer newCustomer = Customer(
        customerId: userUID,
        customerName: '',
        customerEmail: email,
        customerPassword: password,
        customerGender: '',
        customerBirthDay: null,
        isActive: true,
        createdBy: 'system',
        createDate: DateTime.now(),
        updatedDate: DateTime.now(),
        updatedBy: 'system',
        customerAvatar: '',
      );

      // Lưu đối tượng Customer vào Firestore
      await docRef.set(newCustomer.toMap());

      showDialog<void>(
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
    }
  } catch (e) {
    String errorMessage = '$e';
    if (errorMessage.contains('invalid-credential')) {
      errorMessage = 'Tài khoản không tồn tại hoặc sai mật khẩu';
    }

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
                          errorMessage,
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
              ]);
        });
  }
}
