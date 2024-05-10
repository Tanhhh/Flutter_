import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/Cartitem.dart';
import 'package:flutter_ltdddoan/page/Cart/cartbottomBar.dart';

import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart'; // Import CartRepository
import 'package:provider/provider.dart';

class Cartpage extends StatelessWidget {
  const Cartpage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
            Provider.of<CartRepository>(context, listen: false)
                .clearSelectedItems();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Giỏ hàng",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Consumer<CartRepository>(
              builder: (context, cart, child) {
                final itemCount = cart.itemCount;
                return Text(
                  "($itemCount)",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<CartRepository>(
        builder: (context, cart, child) {
          if (cart.cartItems.isEmpty) {
            return Center(
              child: Text(
                'Chưa có sản phẩm trong giỏ hàng',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final product = cart.cartItems[index];
                    return Cartitem(
                      imageUrl: product.image,
                      productName: product.productName,
                      defaultPrice: product.price,
                      initialQuantity: product.quantity,
                      sizeName: product.sizeName,
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CartBottomBar(),
    );
  }
}
