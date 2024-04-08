import 'package:flutter/material.dart';

class productGirdView extends StatelessWidget {
  const productGirdView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.68,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 1; i < 8; i++)
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFFeDeCF2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Icon(
                      Icons.favorite_border,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset("assets/images/img_$i.jpg"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.center,
                  child: Text(
                    "promax $i",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "\$55",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.shopping_cart)
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
