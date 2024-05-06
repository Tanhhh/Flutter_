import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/home/home.page.dart';
import 'package:flutter_ltdddoan/page/product/provider/favoriteproduct_get.dart';
import 'package:flutter_ltdddoan/page/product/provider/productquantity_get.dart';
import 'package:flutter_ltdddoan/page/product/provider/size_get.dart';
import 'package:flutter_ltdddoan/page/product/widget/size_button_dart';
import 'package:flutter_ltdddoan/page/product/widget/update_quantityproduct.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:flutter_ltdddoan/repositories/products/favorite_product.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../widget/view_fullimages.dart';

class ProductDetailsViewBottom extends StatefulWidget {
  final String productId;
  final ProductRepository productRepository;

  ProductDetailsViewBottom({
    Key? key,
    required this.productId,
    required this.productRepository,
  }) : super(key: key);

  @override
  _ProductDetailsViewBottomState createState() =>
      _ProductDetailsViewBottomState();
}

class _ProductDetailsViewBottomState extends State<ProductDetailsViewBottom> {
  final QuantityController _quantityController = Get.put(QuantityController());
  final SizeController _sizeController = Get.put(SizeController());
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _quantityController.reset();
    _sizeController.reset();
    currentUser = UserRepository().getUserAuth();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    if (currentUser == null || !mounted) return;
    bool favoriteStatus = await FavoriteProductRepository()
        .isProductFavorite(widget.productId, currentUser!.uid);
    if (!mounted) return;
    _favoriteController.isFavorite.value = favoriteStatus;
    _favoriteController.update(); // Cập nhật trạng thái sử dụng GetX
  }

  @override
  Widget build(BuildContext context) {
    final cartRepository = Provider.of<CartRepository>(context, listen: false);

    return Scaffold(
      body: DraggableScrollableSheet(
        initialChildSize: 0.98,
        minChildSize: 0.7,
        maxChildSize: 1,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return FutureBuilder<Product?>(
            future: widget.productRepository.getProductById(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Product? product = snapshot.data;
                if (product != null) {
                  return FutureBuilder<List<String>>(
                    future: widget.productRepository
                        .getProductSizes(widget.productId),
                    builder: (context, sizeSnapshot) {
                      if (sizeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (sizeSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${sizeSnapshot.error}'));
                      } else {
                        List<String> sizes = sizeSnapshot.data ?? [];
                        NumberFormat currencyFormat =
                            NumberFormat.currency(locale: 'vi_VN', symbol: '');
                        String formattedPrice =
                            currencyFormat.format(product.price);
                        String formattedPriceSale =
                            currencyFormat.format(product.priceSale);

                        return Stack(
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  Container(
                                    color: Color(0xFFF1F4FB),
                                    height: MediaQuery.of(context).size.height *
                                        .32,
                                    padding: const EdgeInsets.only(bottom: 30),
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        CarouselSlider(
                                          items:
                                              product.imageUrls.map((imageUrl) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FullScreenImage(
                                                          imageUrls:
                                                              product.imageUrls,
                                                          initialIndex: 0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                          options: CarouselOptions(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .30,
                                            aspectRatio: 16 / 9,
                                            viewportFraction: 1.0,
                                            enableInfiniteScroll: false,
                                            autoPlay: false,
                                          ),
                                        ),
                                        Positioned(
                                          top: 100,
                                          right: 30,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black12,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 350,
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
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
                                                    text: (product.priceSale >
                                                                0 &&
                                                            product.isSale)
                                                        ? formattedPriceSale
                                                        : formattedPrice,
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color:
                                                          (product.priceSale >
                                                                      0 &&
                                                                  product
                                                                      .isSale)
                                                              ? Colors
                                                                  .deepOrange
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: 'VND',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          (product.priceSale >
                                                                      0 &&
                                                                  product
                                                                      .isSale)
                                                              ? Colors
                                                                  .deepOrange
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                for (int i = 0;
                                                    i < product.rating;
                                                    i++)
                                                  Icon(Icons.star,
                                                      color: Colors.yellow,
                                                      size: 20),
                                                for (int i = product.rating;
                                                    i < 5;
                                                    i++)
                                                  Icon(Icons.star,
                                                      color: Colors.grey,
                                                      size: 20),
                                              ],
                                            ),
                                            QuantitySelector(),
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
                                          child: Obx(() => Row(
                                                children: sizes.map((size) {
                                                  return SizeButton(
                                                    size: size,
                                                    isTapped: size ==
                                                        _sizeController
                                                            .selectedSize.value,
                                                    onPressed: () {
                                                      _sizeController
                                                          .setSelectedSize(
                                                              size);
                                                    },
                                                  );
                                                }).toList(),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            bottom: 10),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_sizeController.selectedSize
                                                .value.isNotEmpty) {
                                              cartRepository.addToCart(
                                                productId: widget.productId,
                                                sizeName: _sizeController
                                                    .selectedSize.value,
                                                quantity: _quantityController
                                                    .quantity.value,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Đã thêm vào giỏ hàng'),
                                                duration: Duration(seconds: 1),
                                              ));
                                              await Future.delayed(
                                                  Duration(seconds: 2));
                                              Navigator.pop(
                                                  context); // Đóng modal
                                              Navigator.pushReplacement(
                                                // Load lại trang
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HomePage(),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Hãy chọn size'),
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: Color(0xFF6342E8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                'Thêm vào giỏ hàng',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async {
                                          if (currentUser != null) {
                                            _favoriteController
                                                .toggleFavorite(); // Thay đổi trạng thái của nút yêu thích
                                            if (_favoriteController
                                                .isFavorite.value) {
                                              await FavoriteProductRepository()
                                                  .addToFavorites(
                                                      widget.productId,
                                                      currentUser!.uid);
                                            } else {
                                              await FavoriteProductRepository()
                                                  .removeFromFavorites(
                                                      widget.productId,
                                                      currentUser!.uid);
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Bạn cần đăng nhập để thêm sản phẩm vào danh sách yêu thích'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        },
                                        child: Obx(() => Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _favoriteController
                                                        .isFavorite.value
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _favoriteController
                                                        .isFavorite.value
                                                    ? Colors.red
                                                    : Colors.black,
                                                size: 40,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
        },
      ),
    );
  }
}
