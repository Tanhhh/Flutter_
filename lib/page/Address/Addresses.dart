import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import '../Address/Widgets/Single_address.dart';
import '../Address/add_new_address.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/repositories/address/address_repository.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<CustomerAddress> addresses = [];
  int selectedAddressIndex = -1;
  CustomerAddress? selectedAddress; //Biến tạm lưu address được chọn
  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  void loadAddresses() async {
    AddressRepository repository = AddressRepository();
    String customerId = "";
    String? userId = UserRepository().getUserAuth()?.uid;
    if (userId != null) {
      customerId = userId;
    }
    addresses = await repository.getAddressesByCustomerId(customerId);
    setState(() {});
  }

  void handleAddressSelection(int index) {
    setState(() {
      if (selectedAddressIndex == index) {
        selectedAddressIndex = -1;
        selectedAddress = null;
      } else {
        selectedAddressIndex = index;
        selectedAddress = addresses[index];
        Navigator.of(context).pop();
      }
    });
  }

  void _handleAddressUpdated(String customerAddressId) async {
    AddressRepository repository = AddressRepository();
    String customerId = "";
    String? userId = UserRepository().getUserAuth()?.uid;
    if (userId != null) {
      customerId = userId;
    }
    addresses = await repository.getAddressesByCustomerId(customerId);
    setState(() {
      addresses = addresses;
    });
  }

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
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final updatedAddresses = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewAdressScreen(),
                    ),
                  );
                  if (updatedAddresses != null) {
                    setState(() {
                      addresses = updatedAddresses;
                    });
                  }
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
                          Icon(Icons.add),
                          SizedBox(
                            width: 24,
                          ),
                          Text(
                            "Thêm địa chỉ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        ">",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              ...addresses.map((address) {
                int index = addresses.indexOf(address);
                return GestureDetector(
                  onTap: () {
                    handleAddressSelection(index);
                  },
                  child: SingleAddress(
                    selectedAddress: selectedAddressIndex == index,
                    name: 'Tên: ${address.name}',
                    phone: 'Điện thoại: ${address.phone}',
                    addressNote:
                        'Địa chỉ: ${address.addressNote}, ${address.address}',
                    customerAddressId: '${address.customerAddressId}',
                    onAddressUpdated: _handleAddressUpdated,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
