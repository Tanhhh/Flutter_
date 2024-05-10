import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/home/home.page.dart';
import 'package:flutter_ltdddoan/page/product/widget/addtocartbottom_widget.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/product_model.dart';
import '../../product/productdetail.dart';
import '../../../repositories/auth/user_repository.dart';
import '../../../repositories/products/favorite_product.dart';

class ItemWidget extends StatefulWidget {
  final Product product;
  const ItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

final CartRepository cartRepository = CartRepository();

class _ItemWidgetState extends State<ItemWidget> {
  RxBool isFavorite = false.obs;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository().getUserAuth();

    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    if (currentUser == null) return;
    bool favoriteStatus = await FavoriteProductRepository()
        .isProductFavorite(widget.product.productId, currentUser!.uid);
    isFavorite.value = favoriteStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product.imageUrls.isEmpty) {
      return Container();
    }
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    String formattedPrice = currencyFormat.format(widget.product.price);

    // Tính phần trăm giảm giá
    double discountPercentage =
        (widget.product.price - widget.product.priceSale) /
            widget.product.price *
            100;
    String formattedDiscountPercentage = discountPercentage.toStringAsFixed(0);

    // Định nghĩa widget để hiển thị giá
    Widget priceWidget;
    if (widget.product.isSale && widget.product.priceSale > 0) {
      String formattedSalePrice =
          currencyFormat.format(widget.product.priceSale);
      priceWidget = Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  widget.product.rating,
                  (index) => Icon(Icons.star, color: Colors.yellow, size: 15),
                ),
              ),
              SizedBox(height: 5),
              Text(
                formattedSalePrice + 'VND',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Giảm giá ${formattedDiscountPercentage}%',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Hiển thị giá không sale
      priceWidget = Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  widget.product.rating,
                  (index) => Icon(Icons.star, color: Colors.yellow, size: 15),
                ),
              ),
              SizedBox(height: 5),
              Text(
                formattedPrice + 'VND',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      // Sử dụng GestureDetector để bắt sự kiện nhấn
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsView(
              productId: widget.product.productId,
              productRepository: ProductRepository(),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
        height: 360,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4FB),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF1F4FB),
                        ),
                        width: 60,
                        height: 60,
                      ),
                      // Nút yêu thích
                      Obx(() => InkWell(
                            onTap: () async {
                              String message;

                              try {
                                if (isFavorite.value) {
                                  await FavoriteProductRepository()
                                      .removeFromFavorites(
                                    widget.product.productId,
                                    currentUser!.uid,
                                  );
                                  message = "Hủy yêu thích thành công";
                                } else {
                                  await FavoriteProductRepository()
                                      .addToFavorites(
                                    widget.product.productId,
                                    currentUser!.uid,
                                  );
                                  message = "Yêu thích thành công";
                                }
                              } catch (error) {
                                message = "Failed to perform operation: $error";
                              }

                              // Hiển thị thông báo thành công hoặc thất bại
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Text(
                                        message,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Đóng hộp thoại
                                              // Nếu thao tác thành công, reload lại trang
                                              if (message
                                                  .contains("thành công")) {
                                                // Thực hiện reload lại trang ở đây
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFF6342E8)),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );

                              // Cập nhật trạng thái của biểu tượng yêu thích
                              isFavorite.value = !isFavorite.value;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite.value
                                    ? Colors.red
                                    : Colors.black,
                                size: 40,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 0,
                  bottom: 10,
                  left: 0,
                  child: Image.network(
                    widget.product.imageUrls[0],
                    width: 150,
                    height: 190,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Failed to load image');
                    },
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsView(
                      productId: widget.product.productId,
                      productRepository: ProductRepository(),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      priceWidget,
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6342E8).withOpacity(0.5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: ProductDetailsViewBottom(
                                    productId: widget.product.productId,
                                    productRepository: ProductRepository(),
                                  ),
                                );
                              },
                            ).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            });
                          },
                          icon: Icon(Icons.add_shopping_cart_rounded),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
