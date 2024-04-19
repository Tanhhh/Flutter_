import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/customer_model.dart';
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

    QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .where('customerEmail', isEqualTo: email)
        .get();

    if (emailSnapshot.docs.isNotEmpty) {
      throw 'Email đã được sử dụng.';
    }

    // Tạo một tham chiếu tới một tài liệu mới trong collection 'customers'
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('customers').add({});

    // Lấy document ID của tài liệu mới được tạo
    String documentId = docRef.id;

    // Tạo đối tượng Customer từ thông tin đăng ký và gán document ID vào trường customerId
    Customer newCustomer = Customer(
      customerId: documentId,
      customerName: name,
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

    print('Đăng ký thành công!');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Đăng ký thành công!'),
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
