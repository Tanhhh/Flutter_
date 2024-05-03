import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Address/edit_address.dart';

typedef OnAddressUpdated = void Function(String customerAddressId);

class SingleAddress extends StatelessWidget {
  const SingleAddress({
    Key? key,
    required this.selectedAddress,
    required this.name,
    required this.phone,
    required this.addressNote,
    required this.customerAddressId,
    required this.onAddressUpdated,
  }) : super(key: key);

  final bool selectedAddress;
  final String name;
  final String phone;
  final String addressNote;
  final String customerAddressId;
  final OnAddressUpdated onAddressUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  _handleEditAddress(context);
                },
                child: Text(
                  'Chỉnh sửa',
                  style: TextStyle(color: Color(0xFF6342e8)),
                ),
              ),
            ],
          ),
          Text(
            phone,
          ),
          Text(
            addressNote,
          ),
          Divider(),
        ],
      ),
    );
  }

  void _handleEditAddress(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          customerAddressId: customerAddressId,
        ),
      ),
    );
    onAddressUpdated(customerAddressId);
  }
}
