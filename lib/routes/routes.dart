import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/auth/login/login.page.dart';
import 'package:flutter_ltdddoan/page/auth/register/register.page.dart';
import 'package:flutter_ltdddoan/page/home/home.page.dart';
import 'package:flutter_ltdddoan/page/splash/splash.page.dart';
import 'package:flutter_ltdddoan/page/splash/splash_v1.page.dart';
import '../page/customer/profile.dart';

class Routes {
  Routes._();
  static const String splash = '/';
  static const String home = '/home';
  static const String splash_v1 = '/v1';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashPage(),
    splash_v1: (_) => const SplashV1Page(),
    login: (_) => LoginPage(),
    register: (_) => RegisterPage(),
    home: (_) => const HomePage(),
    profile: (_) => UserProfilePage(),
  };
}
