import 'package:flutter/material.dart';

class ProductDetailsBottom extends StatelessWidget {
  final VoidCallback addToCartCallback;
  final VoidCallback otherButtonCallback;

  const ProductDetailsBottom({
    Key? key,
    required this.addToCartCallback,
    required this.otherButtonCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Remove fixed height
        // height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(
                      color: Color(0xFF6342E8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    onPressed: addToCartCallback,
                    child: Text('Thêm vào giỏ hàng'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: otherButtonCallback,
                      child: Text('Button khác'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
