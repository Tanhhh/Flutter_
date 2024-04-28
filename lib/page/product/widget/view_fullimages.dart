import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FullScreenImage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImage({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Loại bỏ icon quay trở lại
        automaticallyImplyLeading: false,
        // Thêm nút X bên phải của AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: CarouselSlider.builder(
          itemCount: imageUrls.length,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            initialPage: initialIndex,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Image.network(imageUrls[index]);
          },
        ),
      ),
    );
  }
}
