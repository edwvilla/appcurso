import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final apiService = ApiService();
  final LoginController loginController = Get.find<LoginController>();

  final _favoriteProducts = <Product>[].obs;
  final _shoppingCartProducts = <Map>[].obs;

  List<Product> get favoriteProducts => _favoriteProducts;
  List<Map> get shoppingCartProducts => _shoppingCartProducts;

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

  static const String kProduct = "product";
  static const String kQuantity = "quantity";

  void addShoppingCartProduct(Product product) {
    final entry = {
      kProduct: product,
      kQuantity: 1,
    };

    final index = _shoppingCartProducts.indexWhere((element) {
      final Map map = element;
      final Product p = map[kProduct];
      return p == product;
    });

    if (index == -1) {
      _shoppingCartProducts.add(entry);
    } else {
      final Map map = _shoppingCartProducts[index];
      map[kQuantity] = map[kQuantity] + 1;
      _shoppingCartProducts[index] = map;
    }
  }

  void removeShoppingCartProduct(Product product) {
    final index = _shoppingCartProducts.indexWhere((element) {
      final Map map = element;
      final Product p = map[kProduct];
      return p == product;
    });

    if (index == -1) {
      return;
    }

    final Map map = _shoppingCartProducts[index];
    final int quantity = map[kQuantity];
    if (quantity > 1) {
      map[kQuantity] = quantity - 1;
      _shoppingCartProducts[index] = map;
    } else {
      _shoppingCartProducts.removeAt(index);
    }
  }

  int getShoppingCartProductQuantity(Product product) {
    final index = _shoppingCartProducts.indexWhere((element) {
      final Map map = element;
      final Product p = map[kProduct];
      return p == product;
    });

    if (index == -1) {
      return 0;
    }

    final Map map = _shoppingCartProducts[index];
    return map[kQuantity];
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
