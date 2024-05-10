import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ltdddoan/page/Cart/provider/cart.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_paymentmethod.dart';
import 'package:flutter_ltdddoan/page/Payment/provider/get_totalprice.dart';
import 'package:flutter_ltdddoan/page/discount/provider/get_discount.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_ltdddoan/routes/routes.dart';
import './page/Address/provider/get_address.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartRepository>(
          create: (_) => CartRepository(),
        ),
        ChangeNotifierProvider<SelectedAddressProvider>(
          create: (_) => SelectedAddressProvider(),
        ),
        ChangeNotifierProvider<SelectedPaymentProvider>(
          create: (_) => SelectedPaymentProvider(),
        ),
        ChangeNotifierProvider<TotalPriceProvider>(
          create: (_) => TotalPriceProvider(),
        ),
        ChangeNotifierProvider<SelectedDiscountProvider>(
          create: (_) => SelectedDiscountProvider(),
        ),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: Routes.routes,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
