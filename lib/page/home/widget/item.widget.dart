import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
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
  bool isFavorite = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository().getUserAuth();

    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    if (currentUser == null) return; // Kiểm tra nếu currentUser là null
    bool favoriteStatus = await FavoriteProductRepository()
        .isProductFavorite(widget.product.productId, currentUser!.uid);
    setState(() {
      isFavorite = favoriteStatus;
    });
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
          MaterialPageRoute(builder: (context) => ProductDetailsView()),
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
                      InkWell(
                        onTap: () async {
                          if (isFavorite) {
                            await FavoriteProductRepository()
                                .removeFromFavorites(
                                    widget.product.productId, currentUser!.uid);
                          } else {
                            await FavoriteProductRepository().addToFavorites(
                                widget.product.productId, currentUser!.uid);
                          }
                          // Cập nhật trạng thái của biểu tượng yêu thích
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
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
                  MaterialPageRoute(builder: (context) => ProductDetailsView()),
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
                            cartRepository.addToCart(
                                widget.product); // Thêm sản phẩm vào giỏ hàng
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Sản phẩm đã được thêm vào giỏ hàng.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
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
