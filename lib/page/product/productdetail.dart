import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import '../../model/product_model.dart';
import 'productbottom_bar.dart';

class ProductDetailsView extends StatelessWidget {
  final String productId; // ID của sản phẩm
  final ProductRepository
      productRepository; // Repository để lấy thông tin sản phẩm

  ProductDetailsView({
    Key? key,
    required this.productId, // Truyền ID của sản phẩm vào constructor
    required this.productRepository, // Truyền ProductRepository vào constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: productRepository.getProductById(productId), // Lấy sản phẩm từ ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Product? product = snapshot.data;
          if (product != null) {
            return Scaffold(
              backgroundColor: Color(0xFFF1F4FB),
              appBar: AppBar(
                backgroundColor: Color(0xFFF1F4FB),
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .35,
                    padding: const EdgeInsets.only(bottom: 30),
                    width: double.infinity,
                    child: Image.network(product.imageUrls.isNotEmpty
                        ? product.imageUrls[0]
                        : ''), // Hiển thị ảnh đầu tiên của sản phẩm (nếu có)
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 1000,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Áo Khoác',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${product.price.toStringAsFixed(0)} VND', // Định dạng giá tiền và thêm VND
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Mô tả',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Chọn Size',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6342E8),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4FB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('M'),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4FB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('L'),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4FB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('XL'),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4FB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('XXL'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Similar This',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.imageUrls
                                        .length, // Số lượng ảnh trong danh sách
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4FB),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          product.imageUrls[index],
                                          height: 70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F4FB),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: ProductDetailsBottom(),
            );
          } else {
            return Center(child: Text('Product not found'));
          }
        }
      },
    );
  }
}
