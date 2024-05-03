import 'package:flutter_ltdddoan/repositories/products/favorite_product.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final FavoriteProductRepository _repository = FavoriteProductRepository();

  // Hàm thêm sản phẩm vào danh sách yêu thích
  Future<void> addToFavorites(String productId, String userId) async {
    try {
      await _repository.addToFavorites(productId, userId);
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào mục yêu thích: $e');
    }
  }

  // Hàm xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFromFavorites(String productId, String userId) async {
    try {
      await _repository.removeFromFavorites(productId, userId);
    } catch (e) {
      print('Lỗi khi xóa sản phẩm khỏi mục yêu thích: $e');
    }
  }

  // Stream để lắng nghe danh sách sản phẩm yêu thích
  Stream<List<String>> getFavoriteProducts() {
    return _repository.getFavoriteProducts();
  }

  // Kiểm tra xem một sản phẩm có trong danh sách yêu thích của người dùng hay không
  Future<bool> isProductFavorite(String productId, String userId) async {
    try {
      return await _repository.isProductFavorite(productId, userId);
    } catch (e) {
      print('Lỗi khi kiểm tra sản phẩm yêu thích: $e');
      return false;
    }
  }
}
