import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/product_model.dart';

class ItemWidget extends StatelessWidget {
  final Product product;
  const ItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi giá thành định dạng tiền
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    String formattedPrice = currencyFormat.format(product.price);

    // Kiểm tra và hiển thị giá sale nếu có
    Widget priceWidget;
    if (product.isSale && product.priceSale > 0) {
      // Gạch ngang giá gốc
      String formattedSalePrice = currencyFormat.format(product.priceSale);
      priceWidget = Column(
        children: [
          Text(
            formattedPrice + 'VND',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(height: 5),
          Text(
            formattedSalePrice + 'VND',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ],
      );
    } else {
      // Hiển thị giá không sale
      priceWidget = Text(
        formattedPrice + 'VND',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      );
    }

    return SizedBox(
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
                top: 30,
                right: 0,
                bottom: 10,
                left: 0,
                child: Image.network(
                  product.imageProduct,
                  width: 150,
                  height: 190,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image');
                  },
                ),
              )
            ],
          ),
          Text(
            product.name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          priceWidget,
        ],
      ),
    );
  }
}
