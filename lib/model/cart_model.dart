class Cart {
  final String productName;
  final String sizeName;
  int quantity;
  double price;
  String image;

  Cart({
    required this.productName,
    required this.sizeName,
    required this.quantity,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'sizeName': sizeName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productName: map['productName'],
      sizeName: map['sizeName'],
      quantity: map['quantity'],
      price: map['price'],
      image: map['image'],
    );
  }
}
