import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/splash/widget/button.widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.44,
            child: Stack(
              children: [
                Container(color: const Color(0xFF6342E8)),
                Positioned(
                    top: 20,
                    right: 0,
                    child: Image.asset(Assets.images.vLg.path)),
                Positioned(
                    right: 10, child: Image.asset(Assets.images.fashion.path)),
                Positioned(
                    top: 120,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Get’s started with Geeta.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Đã có tài khoản?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                Positioned(
                    left: 20,
                    bottom: 30,
                    child: Text("Register".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ))),
                Positioned(
                  left: 20,
                  top: MediaQuery.of(context).padding.top,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(Assets.images.backArrow.path),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Tên của bạn",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Họ và tên",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      prefixIcon:
                          Image.asset(Assets.images.envelopeSimple.path),
                      suffixIcon: const Icon(
                        Icons.error,
                        color: Color(0xFF6342E8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Địa chỉ Email",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "hlo@geeta.co",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Image.asset(Assets.images.lock.path)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Mật khẩu",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Nhập mật khẩu",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Image.asset(Assets.images.lock.path)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ButtonWidget(
                    height: 65,
                    onTap: () {},
                    title: 'Đăng ký',
                    isFilled: true,
                    filledColor: const Color(0xFF6342E8),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
