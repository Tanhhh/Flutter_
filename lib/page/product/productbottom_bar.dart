import 'package:flutter/material.dart';

class ProductDetailsBottom extends StatelessWidget {
  const ProductDetailsBottom({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 130,
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
            Container(
              height: 50,
              alignment: Alignment.center,
              width: 450,
              decoration: BoxDecoration(
                color: Color(0xFF6342E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  // Hiển thị BottomModalPayment khi button được nhấn
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Thêm Vào Giỏ Hàng",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
