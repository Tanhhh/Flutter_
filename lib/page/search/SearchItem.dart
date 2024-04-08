import 'girdview.dart';
import 'SearchAppBar.dart';
import 'package:flutter/material.dart';

class searchItem extends StatelessWidget {
  const searchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SearchAppBar(),
          Container(
            // height: 800,
            padding: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFeDeCF2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Tìm sản phẩm...",
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.search),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "139 sản phẩm được tìm thấy",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                productGirdView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
