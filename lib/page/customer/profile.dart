import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ltdddoan/page/product/widget/view_full1image.dart';
import 'package:flutter_ltdddoan/repositories/auth/login_repository.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:get/get.dart';
import '../../repositories/customer/saveprofile_repository.dart';
import 'package:intl/intl.dart';
import 'upload_avt.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextEditingController hoTenController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController namsinhController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController avtController = TextEditingController();
bool isHoTenEditable = false;
bool isEmailEditable = false;
bool isHoTenIconTapped = false;
bool isEmailIconTapped = false;
String? userId = UserRepository().getUserAuth()?.uid;

String formatDate(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

class UserProfilePage extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<UserProfilePage> {
  String? avtImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _restoreIconStates();
    _fetchAvtImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân',
            style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white30,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/menu');
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Xem ảnh'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleImagePage(
                                      imageUrl: avtImageUrl!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.upload),
                              title: Text('Tải ảnh lên'),
                              onTap: () {
                                Navigator.pop(context); // Đóng modal trước đó
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            AppBar(
                                              title: Text(
                                                'Ảnh đại diện',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              centerTitle: true,
                                              automaticallyImplyLeading:
                                                  false, // Loại bỏ icon back
                                              actions: [
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              child: Divider(
                                                color: Colors.grey,
                                                height: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              child: ImageUploaderWidget(
                                                onImageSelected: () {
                                                  _fetchAvtImageUrls();
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 16.0),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          avtImageUrl != null && avtImageUrl!.isNotEmpty
                              ? NetworkImage(avtImageUrl!) as ImageProvider
                              : AssetImage("assets/images/avt.png")
                                  as ImageProvider,
                    ),
                    Positioned(
                      right: -2,
                      bottom: -5,
                      child: SizedBox(
                        height: 42,
                        width: 42,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        AppBar(
                                          title: Text(
                                            'Ảnh đại diện',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          centerTitle: true,
                                          automaticallyImplyLeading:
                                              false, // Loại bỏ icon back
                                          actions: [
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: ImageUploaderWidget(
                                            onImageSelected: () {
                                              _fetchAvtImageUrls();
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child:
                              SvgPicture.asset("assets/icons/Camera Icon.svg"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  User? currentUser = UserRepository().getUserAuth();
                  if (currentUser != null) {
                    await resetPassword(currentUser.email!, context);
                  } else {
                    // Xử lý trường hợp currentUser là null
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  minimumSize: Size(60, 50),
                  backgroundColor: Color(0xFF6342E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  'Reset Mật Khẩu',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 20),
            buildEditableTextField(
              controller: hoTenController,
              isEditable: isHoTenEditable,
              labelText: 'Họ và Tên',
              onTapIcon: () {
                setState(() {
                  if (!isHoTenEditable) {
                    hoTenController.clear();
                  }
                  isHoTenEditable = !isHoTenEditable;
                  isHoTenIconTapped = !isHoTenIconTapped;
                  UserProfileRepository.saveIconState(isHoTenIconTapped);

                  if (!isHoTenEditable) {
                    isHoTenIconTapped = false;
                  }
                });
              },
              isIconTapped: isHoTenIconTapped,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: namsinhController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Ngày sinh',
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Hiển thị lịch
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              // Cập nhật ngày sinh thành dạng chuỗi ngày/tháng/năm
                              setState(() {
                                namsinhController.text =
                                    formatDate(selectedDate);
                              });
                            }
                          });
                        },
                        icon: Icon(Icons.calendar_today),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: genderController.text.isNotEmpty
                        ? genderController.text
                        : 'Chọn',
                    decoration: InputDecoration(
                      labelText: 'Giới tính',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Chọn') {
                          genderController.text =
                              ''; // Nếu chọn 'Chọn', lưu vào controller là rỗng
                        } else {
                          genderController.text =
                              newValue ?? ''; // Lưu giá trị mới vào controller
                        }
                      });
                    },
                    items: <String>['Chọn', 'Nam', 'Nữ', 'Khác']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed:
                    _saveDataToFirestore, // Gọi hàm để lưu dữ liệu vào Firestore
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  minimumSize: Size(150, 50),
                ),
                child: Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm lấy dữ liệu từ Firestore
  void _fetchUserData() async {
    await UserProfileRepository.fetchUserData(hoTenController, emailController,
        namsinhController, avtController, genderController);

    if (namsinhController.text.isNotEmpty) {
      DateTime dateTime = DateTime.parse(namsinhController.text);
      namsinhController.text = formatDate(dateTime);
    }
  }

  // Hàm lưu dữ liệu vào Cloud Firestore
  void _saveDataToFirestore() {
    UserProfileRepository.saveCustomerProfileChanges(hoTenController,
        emailController, namsinhController, avtController, genderController);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lưu thành công'), duration: Duration(seconds: 1)),
    );
    Navigator.pushReplacementNamed(context, '/profile');
  }

  // Hàm tạo TextField có chức năng chỉnh sửa và biểu tượng thay đổi màu
  Widget buildEditableTextField({
    required TextEditingController controller,
    required bool isEditable,
    required String labelText,
    required Function onTapIcon,
    required bool isIconTapped,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditable,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          onPressed: () {
            onTapIcon();
          },
          icon: Icon(
            Icons.edit,
            color: isIconTapped
                ? Colors.purple
                : null, // Thay đổi màu của biểu tượng khi được nhấn
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Hàm khôi phục trạng thái của icon từ SharedPreferences
  _restoreIconStates() async {
    await UserProfileRepository.restoreIconStates(isHoTenIconTapped,
        isEmailIconTapped); // Sử dụng phương thức từ repository
  }

  // Hàm lấy danh sách URL của hình ảnh avatar từ Firebase Storage
  _fetchAvtImageUrls() async {
    String? userId = UserRepository().getUserAuth()?.uid;
    String documentId = userId!;
    String? imageUrl = await UserRepository().getLatestImageUrl(documentId);
    setState(() {
      avtImageUrl = imageUrl;
    });
  }
}
