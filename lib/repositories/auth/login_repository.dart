import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
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
      await CartRepository().clearCartItems();
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
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text('Đóng'),
              ),
            ],
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

      // Hiển thị thông báo đăng nhập thành công và chuyển hướng người dùng đến trang chính
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
    }
  } catch (e) {
    String errorMessage = '$e';
    if (errorMessage.contains('invalid-credential')) {
      errorMessage = 'Tài khoản không tồn tại hoặc sai mật khẩu';
    }

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
