import 'package:get/get.dart';

class SizeController extends GetxController {
  final selectedSize = ''.obs;

  void setSelectedSize(String size) {
    selectedSize.value = size;
  }

  void reset() {
    selectedSize.value = '';
  }
}
