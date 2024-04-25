import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State {
  String selectedPrice = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lọc sản phẩm",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          ListTile(
            title: Text('Giới tính'),
            subtitle: Row(
              children: [
                FilterChip(
                  label: Text('Nam'),
                  onSelected: (bool selected) {
// Xử lý khi người dùng chọn giới tính Nam
                  },
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text('Nữ'),
                  onSelected: (bool selected) {
// Xử lý khi người dùng chọn giới tính Nữ
                  },
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text('Unisex'),
                  onSelected: (bool selected) {
// Xử lý khi người dùng chọn giới tính Unisex
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Loại'),
            subtitle: Row(
              children: [
                FilterChip(
                  label: Text('Quần'),
                  onSelected: (bool selected) {
// Xử lý khi người dùng chọn loại Quần
                  },
                ),
                SizedBox(width: 10),
                FilterChip(
                  label: Text('Áo'),
                  onSelected: (bool selected) {
// Xử lý khi người dùng chọn loại Áo
                  },
                ),
// Add more items as needed
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Giá'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
// Hiển thị hộp thoại chọn giá
                    _showPriceDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 10),
                      Text(selectedPrice.isNotEmpty
                          ? selectedPrice
                          : 'Chọn giá'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
// Xử lý khi nhấn nút Reset
                  setState(() {
                    selectedPrice = '';
                  });
                },
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
// Xử lý khi nhấn nút Tìm kiếm
                },
                child: Text('Tìm kiếm'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPriceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn giá'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriceOption(context, 'Thấp đến cao'),
              SizedBox(height: 10),
              _buildPriceOption(context, 'Cao đến thấp'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceOption(BuildContext context, String priceOption) {
    return InkWell(
      onTap: () {
// Xử lý khi người dùng chọn một mức giá
        setState(() {
          selectedPrice = priceOption;
        });
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Icon(Icons.attach_money),
          SizedBox(width: 10),
          Text(priceOption),
        ],
      ),
    );
  }
}
