import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/splash/widget/button.widget.dart';
import 'package:flutter_ltdddoan/routes/routes.dart';
import '../../../repositories/auth/login_repository.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController emailController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              children: [
                Container(color: const Color(0xFF6342E8)),
                Positioned(
                    top: 20,
                    right: 0,
                    child: Image.asset(Assets.images.vLg.path)),
                Positioned(
                    right: 10, child: Image.asset(Assets.images.fashion.path)),
                const Positioned(
                    top: 120,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome Back!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                            "Yay! Bạn quay trở lại rồi! Cảm ơn vì đã mua sắm cùng chúng tôi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        Text(
                            "Chúng tôi đang có nhiều ưu đãi và khuyến mãi hấp dẫn, hãy chọn ngay!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                      ],
                    )),
                Positioned(
                    left: 20,
                    bottom: 30,
                    child: Text("Quên mật khẩu".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ))),
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
                    "Địa chỉ email",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Nhập email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      prefixIcon: Image.asset(
                        Assets.images.envelopeSimple.path,
                        color: Color(0xFF6342E8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    height: 65,
                    onTap: () {
                      resetPassword(emailController.text, context);
                    },
                    title: 'Xác nhận',
                    isFilled: true,
                    filledColor: const Color(0xFF6342E8),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Quay lại trang?",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(color: Color(0xFF6342E8)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
