import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';

class ItemFavorite extends StatelessWidget {
  final String customerId;
  final Product product;

  const ItemFavorite({
    Key? key,
    required this.customerId,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Tăng chiều cao của card
      margin:
          const EdgeInsets.symmetric(vertical: 10), // Khoảng cách giữa các item
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
              const SizedBox(height: 20),
              // Hiển thị Giá ở đây
              Row(
                children: [
                  Text(
                    product.isSale && product.priceSale > 0
                        ? "${product.priceSale.toString()} VND"
                        : "${product.price.toString()} VND",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // Kích thước cho giá
                    ),
                  ),
                  SizedBox(width: 5),
                  if (product.isSale && product.priceSale > 0)
                    Text(
                      "${product.price.toString()} VND",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18, // Kích thước cho giá giảm giá
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.close,
                  size: 24,
                ),
                SizedBox(height: 60),
                // Container chứa icon và GestureDetector
                Container(
                  child: GestureDetector(
                    onTap: () {
                      // Thực hiện chuyển hướng đến trang chi tiết ở đây
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
