import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  const ItemWidget(
      {super.key,
      required this.name,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 360,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 190, // Adjusted height to fit the image
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4FB),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              Positioned(
                top: 30,
                right: 0,
                bottom: 10,
                left: 0,
                child: Image.asset(
                  image,
                  width: 150,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
          Text(
            name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 5), // Added space between text and price
          Text(
            "${price}VND",
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
          )
        ],
      ),
    );
  }
}
