import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final apiService = ApiService();
  final LoginController loginController = Get.find<LoginController>();

  final _favoriteProducts = <Product>[].obs;

  List<Product> get favoriteProducts => _favoriteProducts;

  void toggleFavoriteProduct(Product product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
    } else {
      _favoriteProducts.add(product);
    }
  }

  bool isFavoriteProduct(Product product) {
    return _favoriteProducts.contains(product);
  }

  Future<List<Product>?> getProducts() async {
    final token = loginController.userCredential?.jwt;
    try {
      if (token == null) {
        throw Exception("El usuario no está autenticado");
      }
      return await apiService.getProducts(token: token);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
