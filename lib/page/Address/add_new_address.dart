import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/repositories/address/address_repository.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';

class AddNewAdressScreen extends StatefulWidget {
  const AddNewAdressScreen({Key? key}) : super(key: key);
  @override
  _AddNewAdressScreenState createState() => _AddNewAdressScreenState();
}

class _AddNewAdressScreenState extends State<AddNewAdressScreen> {
  AddressRepository repository = AddressRepository();
  UserRepository userrepository = UserRepository();
  String? selectedTinh;
  String? selectedQuan;
  String? selectedXa;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressNoteController = TextEditingController();
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
                    controller: nameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Họ và tên',
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Số điện thoại',
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 15),
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
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTinh = newValue;
                      });
                    },
                    items: <String>[
                      'An Giang',
                      'Bà Rịa - Vũng Tàu',
                      'Bắc Giang',
                      'Bắc Kạn',
                      'Bạc Liêu',
                      'Bắc Ninh',
                      'Bến Tre',
                      'Bình Định',
                      'Bình Dương',
                      'Bình Phước',
                      'Bình Thuận',
                      'Cà Mau',
                      'Cần Thơ',
                      'Cao Bằng',
                      'Đà Nẵng',
                      'Đắk Lắk',
                      'Đắk Nông',
                      'Điện Biên',
                      'Đồng Nai',
                      'Đồng Tháp',
                      'Gia Lai',
                      'Hà Giang',
                      'Hà Nam',
                      'Hà Nội',
                      'Hà Tĩnh',
                      'Hải Dương',
                      'Hải Phòng',
                      'Hậu Giang',
                      'Hòa Bình',
                      'Hưng Yên',
                      'Khánh Hòa',
                      'Kiên Giang',
                      'Kon Tum',
                      'Lai Châu',
                      'Lâm Đồng',
                      'Lạng Sơn',
                      'Lào Cai',
                      'Long An',
                      'Nam Định',
                      'Nghệ An',
                      'Ninh Bình',
                      'Ninh Thuận',
                      'Phú Thọ',
                      'Quảng Bình',
                      'Quảng Nam',
                      'Quảng Ngãi',
                      'Quảng Ninh',
                      'Quảng Trị',
                      'Sóc Trăng',
                      'Sơn La',
                      'Tây Ninh',
                      'Thái Bình',
                      'Thái Nguyên',
                      'Thanh Hóa',
                      'Thừa Thiên Huế',
                      'Tiền Giang',
                      'Trà Vinh',
                      'Tuyên Quang',
                      'Vĩnh Long',
                      'Vĩnh Phúc',
                      'Yên Bái'
                    ].map<DropdownMenuItem<String>>((String value) {
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
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedQuan = newValue;
                      });
                    },
                    items: <String>[
                      'Quận 1',
                      'Quận 2',
                      'Quận 3',
                      'Quận 4',
                      'Quận 5',
                      'Quận 6',
                      'Quận 7',
                      'Quận 8',
                      'Quận 9',
                      'Quận 10',
                      'Quận 11',
                      'Quận 12',
                      'Quận Bình Tân',
                      'Quận Bình Thạnh',
                      'Quận Gò Vấp',
                      'Quận Phú Nhuận',
                      'Quận Tân Bình',
                      'Quận Tân Phú',
                      'Quận Thủ Đức',
                      'Huyện Bình Chánh',
                      'Huyện Cần Giờ',
                      'Huyện Củ Chi',
                      'Huyện Hóc Môn',
                      'Huyện Nhà Bè'
                    ].map<DropdownMenuItem<String>>((String value) {
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
                      hintText: 'Chọn xã',
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 15, top: 15, bottom: 15),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedXa = newValue;
                      });
                    },
                    items: <String>[
                      'Xã An Lợi Đông',
                      'Xã An Lợi Tây',
                      'Xã An Phú',
                      'Xã An Phước',
                      'Xã An Tịnh',
                      'Xã An Vĩnh Ngãi',
                      'Xã An Định',
                      'Xã An Điền',
                      'Xã An Đông',
                      'Xã An Đức',
                      'Xã An Hải',
                      'Xã An Hòa',
                      'Xã An Hóa',
                      'Xã An Hợi Đông',
                      'Xã An Hợi Tây',
                      'Xã An Hữu',
                      'Xã An Khánh',
                      'Xã An Lạc',
                      'Xã An Mỹ',
                      'Xã An Nghĩa'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressNoteController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Nhập thông tin địa chỉ chi tiết',
                      contentPadding: EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () async {
                if (selectedTinh != null &&
                    selectedQuan != null &&
                    selectedXa != null &&
                    nameController != null &&
                    phoneController != null &&
                    addressNoteController != null) {
                  DateTime now = DateTime.now();
                  String customerId = "";
                  String? userId = UserRepository().getUser()?.id;
                  if (userId != null) {
                    customerId = userId;
                  }
                  CustomerAddress newAddress = CustomerAddress(
                    customerAddressId:
                        (await repository.getNextAddressId()) ?? '',
                    name: nameController.text,
                    phone: phoneController.text,
                    address: (selectedXa ?? "") +
                        ", " +
                        (selectedQuan ?? "") +
                        ", " +
                        (selectedTinh ?? ""),
                    addressNote: addressNoteController.text,
                    createDate: now,
                    updatedDate: now,
                    customerId: customerId,
                  );
                  await repository.addAddress(newAddress);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm địa chỉ thành công!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vui lòng điền đầy đủ thông tin'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
                minimumSize:
                    Size(double.infinity, 50.0), // Kích thước tối thiểu của nút
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
