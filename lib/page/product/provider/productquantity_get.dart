import 'package:get/get.dart';

class QuantityController extends GetxController {
  var quantity = 1.obs;

  void decrease() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void increase() {
    quantity.value++;
  }

  void reset() {
    quantity.value = 1; // Reset selected size to empty string
  }
}
