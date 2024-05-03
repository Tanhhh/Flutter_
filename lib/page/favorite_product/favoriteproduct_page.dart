import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/page/favorite_product/widget/item_list.dart';
import 'package:flutter_ltdddoan/repositories/auth/user_repository.dart';
import 'package:flutter_ltdddoan/repositories/products/favorite_product.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int favoriteProductCount = 0;
  User? currentUser;
  List<Product>? favoriteProducts;

  @override
  void initState() {
    super.initState();
    currentUser = UserRepository().getUserAuth();
    if (currentUser != null) {
      updateFavoriteProductCount();
      fetchFavoriteProducts();
    }
  }

  void updateFavoriteProductCount() async {
    FavoriteProductRepository favoriteProductRepository =
        FavoriteProductRepository();

    String customerId = currentUser!.uid;
    int count =
        await favoriteProductRepository.countFavoriteProducts(customerId);
    setState(() {
      favoriteProductCount = count;
    });
  }

  void fetchFavoriteProducts() async {
    FavoriteProductRepository favoriteProductRepository =
        FavoriteProductRepository();

    String customerId = currentUser!.uid;
    List<Product> products =
        await favoriteProductRepository.getFavoriteProducts(customerId).first;
    setState(() {
      favoriteProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Yêu thích ($favoriteProductCount)",
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
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              30, // Giới hạn chiều cao của ListView
          child: favoriteProducts != null
              ? ListView.builder(
                  itemCount: favoriteProducts!.length,
                  itemBuilder: (context, index) {
                    return ItemFavorite(
                      customerId: currentUser!.uid,
                      product: favoriteProducts![
                          index], // Truyền từng sản phẩm vào ItemFavorite
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
