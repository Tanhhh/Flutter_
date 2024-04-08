import 'package:flutter/material.dart';
import '../Address/Widgets/Single_address.dart';
import '../Address/add_new_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AdressScreenState createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AddressScreen> {
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
            'Tổng tiền',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24), //padding
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewAdressScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add), // Thêm biểu tượng ở đây
                          SizedBox(
                              width:
                                  24), // Khoảng cách 24px giữa biểu tượng và văn bản
                          Text(
                            "Thêm địa chỉ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        ">",
                        style: TextStyle(
                          fontSize: 18, // Đặt kích thước phù hợp
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              SingleAddress(
                  selectedAddress: false,
                  name: 'Name: Nguyễn Văn A',
                  phone: 'Phone: 0944312341',
                  address: 'Trường Huflit, Quận 10, Thành phố HCM, Việt Nam'),
              Divider(),
              SingleAddress(
                  selectedAddress: false,
                  name: 'Name: Nguyễn Văn B',
                  phone: 'Phone: 0911221220',
                  address: 'Trường Huflit, Quận 10, Thành phố HCM, Việt Nam'),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
