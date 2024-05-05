import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/Cartitem.dart';
import 'package:flutter_ltdddoan/page/Cart/cartbottomBar.dart';

import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart'; // Import CartRepository
import 'package:provider/provider.dart';

class Cartpage extends StatelessWidget {
  const Cartpage({Key? key});

  @override
  Widget build(BuildContext context) {
    
    final cartRepository = Provider.of<CartRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
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
            FutureBuilder<void>(
              future: cartRepository.loadCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final itemCount = cartRepository.cartItems.length;
                  return Text(
                    "($itemCount)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: cartRepository.loadCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (cartRepository.cartItems.isEmpty) {
              return Center(
                child: Text(
                  'Không có sản phẩm trong giỏ hàng',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              final itemCount = cartRepository.cartItems.length;
              return Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final product = cartRepository.cartItems[index];
                      return Cartitem(
                        imageUrl: product.image,
                        productName: product.productName,
                        price: product.price,
                        quantity: product.quantity,
                        sizeName: product.sizeName,
                        cartRepository: cartRepository,
                      );
                    },
                  ),
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: CartBottomBar(),
    );
  }
}
