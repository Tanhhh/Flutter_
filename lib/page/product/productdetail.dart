import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/product/widget/addtocart_widget.dart';
import 'package:flutter_ltdddoan/page/product/widget/size_button_dart';
import 'package:flutter_ltdddoan/page/product/widget/view_full1image.dart';
import 'package:intl/intl.dart';
import '../../model/product_model.dart';
import '../../repositories/products/product_detail.dart'; // Import ProductRepository
import 'package:carousel_slider/carousel_slider.dart';
import 'widget/view_fullimages.dart';

class ProductDetailsView extends StatefulWidget {
  final String productId;
  final ProductRepository productRepository;

  ProductDetailsView({
    Key? key,
    required this.productId,
    required this.productRepository,
  }) : super(key: key);

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late Future<Product?> _productFuture;
  late Future<List<String>> _productSizesFuture; // Biến để lưu danh sách size

  @override
  void initState() {
    super.initState();
    _productFuture = widget.productRepository.getProductById(widget.productId);
    _productSizesFuture = widget.productRepository
        .getProductSizes(widget.productId); // Gọi hàm để lấy danh sách size
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Product? product = snapshot.data;
          if (product != null) {
            return FutureBuilder<List<String>>(
              future: _productSizesFuture,
              builder: (context, sizeSnapshot) {
                if (sizeSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (sizeSnapshot.hasError) {
                  return Center(child: Text('Error: ${sizeSnapshot.error}'));
                } else {
                  List<String> sizes =
                      sizeSnapshot.data ?? []; // Lấy danh sách size từ snapshot
                  NumberFormat currencyFormat =
                      NumberFormat.currency(locale: 'vi_VN', symbol: '');
                  String formattedPrice = currencyFormat.format(product.price);
                  String formattedPriceSale =
                      currencyFormat.format(product.priceSale);

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
                        Padding(
                          padding: const EdgeInsets.only(right: 15, top: 15),
                          child: Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                              ),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .32,
                          padding: const EdgeInsets.only(bottom: 30),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleImagePage(
                                    imageUrl: product.imageUrls.isNotEmpty
                                        ? product.imageUrls[0]
                                        : '',
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              product.imageUrls.isNotEmpty
                                  ? product.imageUrls[0]
                                  : '',
                            ),
                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      (product.priceSale > 0 &&
                                                              product.isSale)
                                                          ? formattedPriceSale
                                                          : formattedPrice,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: (product.priceSale >
                                                                0 &&
                                                            product.isSale)
                                                        ? Colors
                                                            .deepOrange // Màu khi giảm giá
                                                        : Colors
                                                            .black, // Màu mặc định
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'VND',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: (product.priceSale >
                                                                0 &&
                                                            product.isSale)
                                                        ? Colors
                                                            .deepOrange // Màu khi giảm giá
                                                        : Colors
                                                            .black, // Màu mặc định
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // Đảm bảo sao và nút được căn chỉnh theo hai bên
                                        children: [
                                          // Hiển thị số sao theo product.rating
                                          Row(
                                            children: [
                                              for (int i = 0;
                                                  i < product.rating;
                                                  i++)
                                                Icon(Icons.star,
                                                    color: Colors.yellow,
                                                    size: 20),
                                              // Hiển thị các sao còn lại màu xám
                                              for (int i = product.rating;
                                                  i < 5;
                                                  i++)
                                                Icon(Icons.star,
                                                    color: Colors.grey,
                                                    size: 20),
                                            ],
                                          ),

                                          Container(
                                            width: 90,
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Icon(CupertinoIcons.minus,
                                                    color: Color(0xFF4C53A5),
                                                    size: 18),
                                                SizedBox(width: 10),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(width: 10),
                                                Icon(CupertinoIcons.plus,
                                                    color: Color(0xFF4C53A5),
                                                    size: 18),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Mô tả',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
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
                                      const SizedBox(height: 15),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: sizes.map((size) {
                                            // Trả về SizeButton cho mỗi size trong danh sách
                                            return SizeButton(
                                              size: size,
                                              onPressed: () {
                                                // Xử lý khi nút được nhấn
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Ảnh sản phẩm',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CarouselSlider.builder(
                                        itemCount: product.imageUrls.length,
                                        options: CarouselOptions(
                                          height: 130.0,
                                          viewportFraction: 0.35,
                                          enableInfiniteScroll: false,
                                          autoPlay: false,
                                          autoPlayCurve: Curves.easeInOut,
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 500),
                                          initialPage: 1,
                                        ),
                                        itemBuilder: (BuildContext context,
                                            int index, int realIndex) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Hiển thị ảnh full screen khi nhấn vào
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenImage(
                                                    imageUrls: product
                                                        .imageUrls, // Truyền danh sách ảnh
                                                    initialIndex:
                                                        index, // Truyền chỉ số ảnh ban đầu
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F4FB),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Image.network(
                                                  product.imageUrls[index],
                                                  height: 100,
                                                  width: 100,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
                    // bottomNavigationBar: ProductDetailsBottom(),
                  );
                }
              },
            );
          } else {
            return Center(child: Text('Product not found'));
          }
        }
      },
    );
  }
}
