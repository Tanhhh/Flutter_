import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final double price;
  final double priceSale;
  final bool isNew;
  final bool isSale;
  final bool isHot;
  final bool isSoldOut;
  final bool isActive;
  final String createdBy;
  final DateTime createDate;
  final DateTime updatedDate;
  final int rating;
  final String genderCategoryId;
  final String productCategoryId;
  final String discountId;
  List<String> imageUrls;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.priceSale,
    required this.isNew,
    required this.isSale,
    required this.isHot,
    required this.isSoldOut,
    required this.isActive,
    required this.createdBy,
    required this.createDate,
    required this.updatedDate,
    required this.rating,
    required this.genderCategoryId,
    required this.productCategoryId,
    required this.discountId,
    required this.imageUrls,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      productId: doc.id,
      name: doc['name'],
      description: doc['description'],
      price: double.parse(doc['price'].toString()),
      priceSale: double.parse(doc['priceSale'].toString()),
      isNew: doc['isNew'],
      isSale: doc['isSale'],
      isHot: doc['isHot'],
      isSoldOut: doc['isSoldOut'],
      isActive: doc['isActive'],
      createdBy: doc['createdBy'],
      createDate: doc['createDate'].toDate(),
      updatedDate: doc['updatedDate'].toDate(),
      rating: doc['rating'],
      genderCategoryId: doc['genderCategoryId'],
      productCategoryId: doc['productCategoryId'],
      discountId: doc['discountId'],
      imageUrls: [],
    );
  }
}
