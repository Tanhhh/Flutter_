import 'package:flutter/material.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({
    super.key,
    required this.selectedAddress,
    required this.name,
    required this.phone,
    required this.address,
});
  final bool selectedAddress;
  final String name;
  final String phone;
  final String address;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      ),
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
                  // Xử lý sự kiện khi người dùng nhấp vào văn bản "Chỉnh sửa"
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
            address,
          ),
        ],
      ),
    );
  }
}