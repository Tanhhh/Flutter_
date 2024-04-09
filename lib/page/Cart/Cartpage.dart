import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/clothes.model.dart';

import 'package:flutter_ltdddoan/page/Cart/cartbottomBar.dart';
import 'package:flutter_ltdddoan/page/Cart/widgets/item.widget.listview.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Giỏ hàng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return itemListView(
                image: product.image,
                name: product.title,
                price: product.price,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CartBottomBar(),
    );
  }
}
