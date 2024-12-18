import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/page/Cart/Cartpage.dart';
import 'package:flutter_ltdddoan/page/Payment/PaymentMethods.dart';
import 'package:flutter_ltdddoan/page/Payment/Purchased.dart';
import 'package:flutter_ltdddoan/page/auth/login/forgot_pass.dart';
import 'package:flutter_ltdddoan/page/auth/login/login.page.dart';
import 'package:flutter_ltdddoan/page/auth/register/register.page.dart';
import 'package:flutter_ltdddoan/page/home/widget/menu_bar.dart';
import 'package:flutter_ltdddoan/page/favorite_product/favoriteproduct_page.dart';
import 'package:flutter_ltdddoan/page/home/home.page.dart';
import 'package:flutter_ltdddoan/page/order_customer/order_listitem.dart';
import 'package:flutter_ltdddoan/page/splash/splash.page.dart';
import 'package:flutter_ltdddoan/page/splash/splash_v1.page.dart';
import '../page/customer/profile.dart';
import '../page/Address/Addresses.dart';
import '../page/discount/discount_page.dart';
import '../page/order_customer/order_detail.dart';

class Routes {
  Routes._();
  static const String splash = '/';
  static const String home = '/home';
  static const String splash_v1 = '/v1';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String addproductcategory = '/addproductcategory';
  static const String favorite = '/favorite';
  static const String myOrder = '/myOrder';
  static const String cart = '/cart';
  static const String address = '/address';
  static const String paymentMethod = '/paymentMethod';
  static const String success = '/success';
  static const String discount = '/discount';
  static const String menu = '/menu';
  static const String orderDetail = '/orderDetail';
  static const String forgotPass = '/forgotPass';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashPage(),
    splash_v1: (_) => const SplashV1Page(),
    login: (_) => LoginPage(),
    register: (_) => RegisterPage(),
    home: (_) => const HomePage(),
    profile: (_) => UserProfilePage(),
    favorite: (_) => FavoritePage(),
    myOrder: (_) => MyOrderScreen(),
    cart: (_) => Cartpage(),
    address: (_) => AddressScreen(),
    paymentMethod: (_) => PaymentMethodsScreen(),
    success: (_) => PurchasedScreen(),
    discount: (_) => PromotionListPage(),
    menu: (_) => ProfileScreen(),
    orderDetail: (_) => OrderDetailPage(orderId: 'maXfS7BtxFoaWSGI5QBH'),
    forgotPass: (_) => ForgotPassPage(),
  };
}
