import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/splash/widget/button.widget.dart';
import 'package:flutter_ltdddoan/routes/routes.dart';

class SplashV1Page extends StatelessWidget {
  const SplashV1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.images.splashV1.path,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(0.8),
          ),
          Image.asset(
            Assets.images.vector.path,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Getta.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.images.shoppingBag.path,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Làm mới phong cách\nthời trang của bạn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Mỗi người đàn ông và phụ nữ đều có phong cách riêng, Geeta. giúp bạn tạo nên phong cách riêng của mình.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ButtonWidget(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  title: 'Đăng nhập',
                  colorBorder: Colors.black,
                  textColor: Colors.black,
                  isFilled: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Hoặc",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.register);
                  },
                  title: 'Đăng ký',
                  isFilled: true,
                  colorBorder: Colors.transparent,
                  filledColor: const Color(0xFF6342E8),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
