import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/routes/routes.dart';

void main() => runApp(const Myapp());

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routes.routes,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
