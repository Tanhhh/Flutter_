import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../repositories/auth/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepository {
  static Future<void> fetchUserData(
    TextEditingController hoTenController,
    TextEditingController emailController,
    TextEditingController namsinhController,
    TextEditingController avtController,
    TextEditingController genderController,
  ) async {
    DocumentSnapshot? currentUser = UserRepository().getUser();
    if (currentUser != null) {
      Map<String, dynamic> data = currentUser.data() as Map<String, dynamic>;
      hoTenController.text = data['customerName'] ?? '';
      emailController.text = data['customerEmail'] ?? '';
      namsinhController.text = data['customerBirthDay'] != null
          ? (data['customerBirthDay'] as Timestamp).toDate().toString()
          : '';
      avtController.text = data['customerAvatar'] ?? '';
      genderController.text = data['customerGender'] ?? '';

      // In giá trị ra console
      print('customerName: ${hoTenController.text}');
      print('customerEmail: ${emailController.text}');
      print('customerBirthDay: ${namsinhController.text}');
      print('customerAvatar: ${avtController.text}');
      print('customerGender: ${genderController.text}');
    }
  }

  static Future<void> restoreIconStates(
    bool isHoTenIconTapped,
    bool isEmailIconTapped,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isHoTenIconTapped = prefs.getBool('isHoTenIconTapped') ?? false;
    isEmailIconTapped = prefs.getBool('isEmailIconTapped') ?? false;
  }

  static Future<void> saveIconState(bool isIconTapped) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIconTapped', isIconTapped);
  }

  static Future<void> saveCustomerProfileChanges(
    TextEditingController hoTenController,
    TextEditingController emailController,
    TextEditingController namsinhController,
    TextEditingController avtController,
    TextEditingController genderController,
  ) async {
    String hoTen = hoTenController.text;
    String email = emailController.text;
    String avtUrl = avtController.text;
    String gioiTinh = genderController.text;

    // Chuyển đổi ngày sinh thành timestamp
    DateTime? namsinhDateTime;
    if (namsinhController.text.isNotEmpty) {
      namsinhDateTime = _parseVietnameseDate(namsinhController.text);
    }

    DocumentSnapshot? currentUser = UserRepository().getUser();
    if (currentUser != null) {
      String userID = currentUser.id;
      // Dữ liệu mới cần cập nhật
      Map<String, dynamic> newData = {
        'customerName': hoTen,
        'customerEmail': email,
        'customerBirthDay': namsinhDateTime,
        'customerAvatar': avtUrl,
        'customerGender': gioiTinh,
      };
      // Thực hiện cập nhật dữ liệu mới vào Firestore
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userID)
          .update(newData)
          .then((value) async {})
          .catchError((error) {
        // Xử lý khi gặp lỗi
        print("Lỗi khi cập nhật dữ liệu: $error");
      });
    }
  }

  static DateTime _parseVietnameseDate(String input) {
    // Tách ngày, tháng, năm từ chuỗi đầu vào
    List<String> parts = input.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid date format');
    }

    // Lấy ra các phần tử ngày, tháng, năm từ chuỗi
    int day = int.parse(parts[0].trim());
    int month = int.parse(parts[1].trim());
    int year = int.parse(parts[2].trim());

    // Tạo đối tượng DateTime từ các phần tử đã lấy
    return DateTime(year, month, day);
  }
}
