// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/cartbottomBar.dart';

class ProductDetailsView extends StatelessWidget {
  ProductDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F4FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4FB),
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            padding: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            child: Image.asset('assets/images/c3.png'),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 1000,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Áo Khoác',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Purple Hoodie',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '400.000 vnd',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Depscription',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor consectetur tortor vitae interdum.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Select Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF6342E8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F4FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('M'),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F4FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('L'),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F4FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('XL'),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F4FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('XXL'),
                            ),
                          ],
                        )
                        // SizedBox(
                        //   height: 110,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) => Container(
                        //       margin: const EdgeInsets.only(right: 6),
                        //       width: 110,
                        //       height: 110,
                        //       decoration: BoxDecoration(
                        //         color: Colors.amber,
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       child: Center(
                        //         child: Image(
                        //           height: 70,
                        //           image: AssetImage('assets/images/c3.png'),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F4FB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CartBottomBar(),
    );
  }
}
