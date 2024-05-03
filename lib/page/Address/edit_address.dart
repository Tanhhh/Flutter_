import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customeraddress.dart';
import 'package:flutter_ltdddoan/repositories/address/address_repository.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ltdddoan/model/dvhcvn_model.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;

class EditAddressScreen extends StatelessWidget {
  final String customerAddressId;
  const EditAddressScreen({
    Key? key,
    required this.customerAddressId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DvhcvnData>(
      create: (_) => DvhcvnData(),
      child: _EditAddressScreen(customerAddressId: customerAddressId),
    );
  }
}

class _EditAddressScreen extends StatefulWidget {
  final String customerAddressId;

  const _EditAddressScreen({Key? key, required this.customerAddressId})
      : super(key: key);

  @override
  _EditAddressScreenState createState() =>
      _EditAddressScreenState(customerAddressId: customerAddressId);
}

String? selectedTinh;
String? selectedQuan;
String? selectedXa;

class _EditAddressScreenState extends State<_EditAddressScreen> {
  final String customerAddressId;
  AddressRepository repository = AddressRepository();
  UserRepository userrepository = UserRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressNoteController = TextEditingController();
  late CustomerAddress address;

  _EditAddressScreenState({required this.customerAddressId});

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    CustomerAddress? fetchedAddress =
        await repository.getAddressByCustomerAddressId(customerAddressId);
    if (fetchedAddress != null) {
      setState(() {
        address = fetchedAddress;
        nameController.text = fetchedAddress.name;
        phoneController.text = fetchedAddress.phone;
        addressNoteController.text = fetchedAddress.addressNote;
      });
    }
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
            'Sửa thông tin địa chỉ',
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
                  Level1(),
                  SizedBox(height: 10),
                  Level2(),
                  SizedBox(height: 10),
                  Level3(),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await repository.deleteAddress(customerAddressId);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'XÓA',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Màu văn bản là màu trắng
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nền của nút
                      minimumSize: Size(double.infinity,
                          50.0), // Kích thước tối thiểu của nút
                    ),
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa hai nút
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedTinh != null &&
                          selectedQuan != null &&
                          selectedXa != null &&
                          nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          addressNoteController.text.isNotEmpty) {
                        DateTime now = DateTime.now();
                        String customerId = "";
                        String? userId = UserRepository().getUserAuth()?.uid;
                        if (userId != null) {
                          customerId = userId;
                        }
                        if (userId != null) {
                          customerId = userId;
                        }
                        CustomerAddress newAddress = CustomerAddress(
                          customerAddressId: customerAddressId,
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
                        await repository.editAddress(newAddress);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã sửa địa chỉ thành công!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        //Navigator.of(context).pop(repository.getAddresses());
                        Navigator.pop(context, newAddress);
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
                      minimumSize: Size(double.infinity,
                          50.0), // Kích thước tối thiểu của nút
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Level1 extends StatelessWidget {
  @override
  Widget build(BuildContext _) => Consumer<DvhcvnData>(
        builder: (context, data, _) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
          child: InkWell(
            onTap: () => _select1(context, data),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.level1?.name ?? 'Chọn tỉnh',
                  style: TextStyle(
                      color: data.level1 != null ? Colors.black : Colors.grey),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );

  void _select1(BuildContext context, DvhcvnData data) async {
    final selected = await _select<dvhcvn.Level1>(context, dvhcvn.level1s);
    if (selected != null) {
      data.level1 = selected;
      selectedTinh = selected.name; // Gán giá trị được chọn vào selectedTinh
    }
  }
}

class Level2 extends StatefulWidget {
  @override
  _Level2State createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data = DvhcvnData.of(context);
    if (data.latestChange == 1) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _select2(context, data));
    }
  }

  @override
  Widget build(BuildContext _) => Consumer<DvhcvnData>(
        builder: (context, data, _) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
          child: InkWell(
            onTap: data.level1 != null ? () => _select2(context, data) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.level2?.name ??
                      (data.level1 != null ? 'Chọn quận' : 'Chọn tỉnh trước'),
                  style: TextStyle(
                      color: data.level1 != null ? Colors.black : Colors.grey),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );

  void _select2(BuildContext context, DvhcvnData data) async {
    final level1 = data.level1;
    if (level1 == null) return;

    final selected = await _select<dvhcvn.Level2>(
      context,
      level1.children,
      header: level1.name,
    );
    if (selected != null) {
      data.level2 = selected;
      selectedQuan = selected.name;
    }
  }
}

class Level3 extends StatefulWidget {
  @override
  _Level3State createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data = DvhcvnData.of(context);
    if (data.latestChange == 2) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _select3(context, data));
    }
  }

  @override
  Widget build(BuildContext _) => Consumer<DvhcvnData>(
        builder: (context, data, _) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
          child: InkWell(
            onTap: data.level2 != null ? () => _select3(context, data) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.level3?.name ??
                      (data.level2 != null ? 'Chọn xã' : 'Chọn quận trước'),
                  style: TextStyle(
                      color: data.level2 != null ? Colors.black : Colors.grey),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );

  void _select3(BuildContext context, DvhcvnData data) async {
    final level2 = data.level2;
    if (level2 == null) return;

    final selected = await _select<dvhcvn.Level3>(
      context,
      level2.children,
      header: level2.name,
    );
    if (selected != null) {
      data.level3 = selected;
      selectedXa = selected.name;
    }
  }
}

Future<T?> _select<T extends dvhcvn.Entity>(
  BuildContext context,
  List<T> list, {
  String header = "",
}) async {
  return await showModalBottomSheet<T?>(
    context: context,
    builder: (_) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // header (if provided)
        if (header.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (header.isNotEmpty) Divider(),

        // entities
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (itemContext, i) {
              final item = list[i];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('#${item.id}, ${item.typeAsString}'),
                onTap: () => Navigator.of(itemContext).pop(item),
              );
            },
            itemCount: list.length,
          ),
        ),
      ],
    ),
  );
}
