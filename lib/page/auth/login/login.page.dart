import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/splash/widget/button.widget.dart';
import 'package:flutter_ltdddoan/routes/routes.dart';
import '../../../repositories/auth/login_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    child: Text("Đăng nhập".toUpperCase(),
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Mật khẩu",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Nhập mật khẩu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Image.asset(
                        Assets.images.lock.path,
                        color: Color(0xFF6342E8),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            // Thay đổi trạng thái ẩn/hiện mật khẩu
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (e) {},
                          ),
                          const Text("Nhớ mật khẩu")
                        ],
                      ),
                      const Text(
                        "Quên mật khẩu ?",
                        style: TextStyle(color: Color(0xFF6342E8)),
                      )
                    ],
                  ),
                  ButtonWidget(
                    height: 65,
                    onTap: () {
                      loginUserWithEmailAndPassword(context,
                          emailController.text, passwordController.text);
                    },
                    title: 'Đăng nhập',
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
                        "Chưa có tài khoản?",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: const Text(
                          "Đăng ký",
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
