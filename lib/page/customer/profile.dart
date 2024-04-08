import 'package:flutter/material.dart';
import '../home/home.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController hoTenController =
    TextEditingController(text: 'Lê Tuấn Anh');
TextEditingController emailController =
    TextEditingController(text: 'letuananh4282@gmail.com');
TextEditingController namsinhController =
    TextEditingController(text: '03/05/2002');
bool isHoTenEditable = false;
bool isEmailEditable = false;
bool isHoTenIconTapped =
    false; // Biến để theo dõi trạng thái của biểu tượng chỉnh sửa Họ và Tên
bool isEmailIconTapped =
    false; // Biến để theo dõi trạng thái của biểu tượng chỉnh sửa Email

class UserProfilePage extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<UserProfilePage> {
  String dropdownValue = 'Nam'; // Giá trị mặc định là 'Nam'

  @override
  void initState() {
    super.initState();
    _restoreIconStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
        backgroundColor: Colors.white30,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF4C54A5),
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
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.black,
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Image.asset(
                                              'images/avt.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop(); // Đóng dialog
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 16, right: 16),
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                              child: Text(
                                                'X',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.upload),
                              title: Text('Upload ảnh lên'),
                              onTap: () {
                                // Xử lý khi chọn "Upload ảnh lên"
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset(
                      'images/avt.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
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
                  isHoTenIconTapped =
                      !isHoTenIconTapped; // Thay đổi trạng thái của biểu tượng
                  _saveIconState(isHoTenIconTapped);
                  // Đặt lại màu của biểu tượng khi thoát hoặc back ra khỏi trường nhập liệu
                  if (!isHoTenEditable) {
                    isHoTenIconTapped = false;
                  }
                });
              },
              isIconTapped: isHoTenIconTapped,
            ),
            SizedBox(height: 20),
            buildEditableTextField(
              controller: emailController,
              isEditable: isEmailEditable,
              labelText: 'Email',
              onTapIcon: () {
                setState(() {
                  if (!isEmailEditable) {
                    emailController.clear();
                  }
                  isEmailEditable = !isEmailEditable;
                  isEmailIconTapped = !isEmailIconTapped;
                  _saveIconState(isEmailIconTapped);
                  if (!isEmailEditable) {
                    isEmailIconTapped = false;
                  }
                });
              },
              isIconTapped: isEmailIconTapped,
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
                              // Xử lý ngày đã chọn ở đây
                              setState(() {
                                namsinhController.text =
                                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
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
                    value: dropdownValue,
                    decoration: InputDecoration(
                      labelText: 'Giới tính',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Nam', 'Nữ', 'Khác']
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
                onPressed: () {
                  // Xử lý khi nhấn nút "Lưu"
                  // Ở đây bạn có thể thực hiện lưu dữ liệu hoặc thực hiện các hành động khác
                  // Sau đó có thể hiển thị thông báo hoặc chuyển hướng trang
                  // Ví dụ: Navigator.pop(context);
                },
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

  // Hàm lưu trạng thái của icon vào SharedPreferences
  _saveIconState(bool isIconTapped) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIconTapped', isIconTapped);
  }

  // Hàm khôi phục trạng thái của icon từ SharedPreferences
  _restoreIconStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isHoTenIconTapped = prefs.getBool('isHoTenIconTapped') ?? false;
      isEmailIconTapped = prefs.getBool('isEmailIconTapped') ?? false;
    });
  }
}
