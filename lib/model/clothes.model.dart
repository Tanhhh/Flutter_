import 'package:flutter_ltdddoan/gen/assets.gen.dart';

class Product {
  final String image, title, price;
  final int id;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
  });
}

List<Product> products = [
  Product(
      id: 1,
      image: Assets.images.hoodie1.path,
      title: "Pink Hoodie",
      price: "400.000"),
  Product(
      id: 2,
      image: Assets.images.jacket1.path,
      title: "Leather Jacket",
      price: "400.000"),
  Product(
      id: 3,
      image: Assets.images.jeans2.path,
      title: "Washed Blue Jeans",
      price: "400.000"),
  Product(
      id: 4,
      image: Assets.images.c3.path,
      title: "Printed Shirt",
      price: "400.000")
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
