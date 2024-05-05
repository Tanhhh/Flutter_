import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/page/favorite_product/favoriteproduct_page.dart';
import 'package:flutter_ltdddoan/page/home/widget/item.widget.dart';
import 'package:flutter_ltdddoan/page/product/productdetail.dart';
import 'package:flutter_ltdddoan/repositories/products/favorite_product.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import 'package:intl/intl.dart';

class ItemFavorite extends StatelessWidget {
  final String customerId;
  final Product product;
  final FavoriteProductRepository favoriteProductRepository;

  const ItemFavorite({
    Key? key,
    required this.customerId,
    required this.product,
    required this.favoriteProductRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    String formattedPrice = currencyFormat.format(product.price);
    String formattedPriceSale = currencyFormat.format(product.priceSale);

    // Tính phần trăm giảm giá
    double discountPercentage =
        (product.price - product.priceSale) / product.price * 100;
    String formattedDiscountPercentage = discountPercentage.toStringAsFixed(0);
    Future<void> showDeleteConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.white,
            content: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Bạn có chắc chắn muốn xóa sản phẩm này?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Color(0xFF6342E8), // Màu viền
                          width: 1, // Độ rộng của viền
                        ),
                      ),
                    ),
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6342E8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF6342E8)),
                    ),
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await favoriteProductRepository.removeFromFavorites(
                          product.productId, customerId);
                      Navigator.pushReplacementNamed(context, '/favorite');
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF1F4FB),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrls.isNotEmpty
                ? product.imageUrls[0]
                : 'placeholder_image_url',
            height: 80,
            width: 80,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image),
          ),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                product.name,
                style: TextStyle(
                  color: Color(0xFF6342E8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    product.isSale && product.priceSale > 0
                        ? formattedPriceSale + ' VND'
                        : formattedPrice + ' VND',
                    style: TextStyle(
                      color: product.isSale && product.priceSale > 0
                          ? Colors.deepOrange
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Kích thước cho giá
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              if (product.isSale &&
                  product.priceSale > 0) // Hiển thị phần trăm giảm giá nếu có
                Text(
                  'Giảm giá ${formattedDiscountPercentage}%',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    // Hiển thị hộp thoại xác nhận trước khi xóa
                    await showDeleteConfirmationDialog(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24,
                  ),
                ),
                SizedBox(height: 60),
                // Container chứa icon và GestureDetector
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsView(
                            productId: product.productId,
                            productRepository: ProductRepository(),
                            cartRepository: cartRepository,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
