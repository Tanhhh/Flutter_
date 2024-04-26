import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemListView extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const ItemListView({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Tăng chiều cao của card
      margin:
          const EdgeInsets.symmetric(vertical: 10), // Khoảng cách giữa các item
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF1F4FB),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image,
            height: 80,
            width: 80,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image),
          ),
          const SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                name,
                style: TextStyle(
                  color: Color(0xFF6342E8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$price",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Kích thước cho giá
                      ),
                    ),
                    TextSpan(
                      text: " VND",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // Kích thước cho VND
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.close,
                size: 24,
              ),
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.minus,
                      color: Color(0xFF4C53A5),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "1",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      CupertinoIcons.plus,
                      color: Color(0xFF4C53A5),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
