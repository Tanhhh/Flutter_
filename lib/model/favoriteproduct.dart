import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProduct {
  final String? favoriteProductId;
  final String customerId;
  final String productId;

  FavoriteProduct({
    required this.favoriteProductId,
    required this.customerId,
    required this.productId,
  });
  factory FavoriteProduct.fromDocument(QueryDocumentSnapshot doc) {
    return FavoriteProduct(
        favoriteProductId: doc.id,
        customerId: doc['customerId'],
        productId: doc['productId']);
  }
}
