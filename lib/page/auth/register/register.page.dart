import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/gen/assets.gen.dart';
import 'package:flutter_ltdddoan/page/splash/widget/button.widget.dart';
import 'package:flutter_ltdddoan/repositories/auth/register_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController(); // Thêm controller cho nhập lại mật khẩu

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Phần giao diện của trang đăng ký
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
                  child: Image.asset(Assets.images.vLg.path),
                ),
                Positioned(
                  right: 10,
                  child: Image.asset(Assets.images.fashion.path),
                ),
                Positioned(
                  top: 120,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Get’s started with Geeta.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Đã có tài khoản?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
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
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 30,
                  child: Text(
                    "Đăng ký".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
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
                      "Địa chỉ Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "hlo@geeta.co",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: Image.asset(
                          Assets.images.envelopeSimple.path,
                          color: Color(0xFF6342E8),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Mật khẩu",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: Image.asset(
                          Assets.images.lock.path,
                          color: Color(0xFF6342E8),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
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
                      height: 30,
                    ),
                    const Text(
                      "Nhập lại mật khẩu", // Thêm trường nhập lại mật khẩu
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Nhập lại mật khẩu",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: Image.asset(
                          Assets.images.lock.path,
                          color: Color(0xFF6342E8),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
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
                      height: 30,
                    ),
                    ButtonWidget(
                      height: 65,
                      onTap: () {
                        String email = emailController.text;
                        String password = passwordController.text;
                        String confirmPassword = confirmPasswordController
                            .text; // Lấy giá trị nhập lại mật khẩu
                        registerUserWithEmailAndPassword(
                            context,
                            confirmPassword,
                            email,
                            password); // Truyền thêm giá trị nhập lại mật khẩu vào hàm đăng ký
                      },
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
            ),
          ),
        ],
      ),
    );
  }
}
