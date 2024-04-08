import 'package:flutter/material.dart';

class AddNewAdressScreen extends StatefulWidget {
  const AddNewAdressScreen({Key? key}) : super (key: key);
  @override
  _AddNewAdressScreenState createState() => _AddNewAdressScreenState();
}


class _AddNewAdressScreenState extends State<AddNewAdressScreen> {
  String? selectedTinh;
  String? selectedQuan;
  String? selectedXa;
  @override
  Widget build(BuildContext context) {
    final leadingWidth = MediaQuery.of(context).size.width / 3;
    final iconWidth = 24.0; // Kích thước của icon
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // Màu nền trong suốt
        leadingWidth: leadingWidth,
        leading: Row(
          children: [
            SizedBox(width: iconWidth), // Đảm bảo không gian cho icon
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              label: SizedBox.shrink(), // Ẩn chữ
              style: ElevatedButton.styleFrom(
                elevation: 0, // Không hiển thị shadow
                backgroundColor: Colors.transparent, // Màu nền trong suốt
                foregroundColor: Colors.black, // Màu chữ
              ),
            ),
          ],
        ),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true, // Canh giữa tiêu đề văn bản
          title: Text(
            'Thêm địa chỉ mới',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24), //padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin liên hệ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Họ và tên',
                      contentPadding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(15.0),),
                      hintText: 'Số điện thoại',
                      contentPadding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Thông tin địa chỉ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: selectedTinh,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Chọn tỉnh',
                      contentPadding: EdgeInsets.only(left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTinh = newValue;
                      });
                    },
                    items: <String>['A', 'B', 'C', 'D']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: selectedQuan,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Chọn quận',
                      contentPadding: EdgeInsets.only(left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedQuan = newValue;
                      });
                    },
                    items: <String>['A', 'B', 'C', 'D']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: selectedXa,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Chọn quận',
                      contentPadding: EdgeInsets.only(left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedXa = newValue;
                      });
                    },
                    items: <String>['A', 'B', 'C', 'D']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(15.0),),
                      hintText: 'Nhập thông tin địa chỉ chi tiết',
                      contentPadding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                // Xử lý khi nút được nhấn
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'LƯU',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Màu văn bản là màu trắng
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6342e8), // Màu nền của nút
                minimumSize: Size(double.infinity, 50.0), // Kích thước tối thiểu của nút
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}