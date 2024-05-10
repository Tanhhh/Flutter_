import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/page/home/widget/item.widget.dart';
import 'package:flutter_ltdddoan/repositories/products/search_product.dart';
import 'package:get/get.dart';
import 'girdview.dart'; // Import widget productGirdView
import 'SearchAppBar.dart'; // Import widget SearchAppBar

class searchItem extends StatefulWidget {
  const searchItem({Key? key});

  @override
  _searchItemState createState() => _searchItemState();
}

class _searchItemState extends State<searchItem> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchResult = []; // Danh sách kết quả tìm kiếm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SearchAppBar(),
          Container(
            padding: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFeDeCF2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Tìm sản phẩm...",
                          ),
                          onChanged: (Value) =>
                              _searchProducts(), // Thực hiện tìm kiếm ngay khi có thay đổi trong ô nhập liệu
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed:
                            _searchProducts, // Bỏ đi vì không cần bấm nút search nữa
                      ),
                    ],
                  ),
                ),
                // Hiển thị kết quả tìm kiếm
                SizedBox(
                  height: 30,
                ),
                if (_searchResult.isEmpty && _searchController.text.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Không tìm thấy kết quả phù hợp",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  SingleChildScrollView(
                    child: SizedBox(
                      width: 600, // hoặc một kích thước cụ thể khác
                      height: 800, // hoặc một kích thước cụ thể khác
                      child: _buildSearchResult(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức thực hiện tìm kiếm sản phẩm dựa trên từ khóa
  void _searchProducts() async {
    String keyword = _searchController.text;
    if (keyword.isNotEmpty) {
      List<Product> result = await getProductsByNameKeyword(keyword);
      setState(() {
        _searchResult = result;
      });
    } else {
      // Nếu từ khóa trống, cập nhật _searchResult với danh sách rỗng và gọi setState
      setState(() {
        _searchResult = [];
      });
    }
  }

  // Phương thức để hiển thị kết quả tìm kiếm
  Widget _buildSearchResult() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30, // Khoảng cách giữa các item theo trục ngang
        childAspectRatio: 3.5 / 4,
      ),
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        final product = _searchResult[index];
        return ItemWidget(
          product: product,
        );
      },
    );
  }
}
