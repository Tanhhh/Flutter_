import 'package:get/get.dart';

class FavoriteController extends GetxController {
  RxBool isFavorite = false.obs;

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}
