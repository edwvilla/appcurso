import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final apiService = ApiService();
  final LoginController loginController = Get.find<LoginController>();

  final _favoriteProducts = <Product>[].obs;
  final _shoppingCartProducts = <Map<String, dynamic>>[].obs;

  void toggleFavoriteProduct(Product product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
    } else {
      _favoriteProducts.add(product);
    }
  }

  bool isFavoriteProduct(Product product) =>
      _favoriteProducts.contains(product);

  void addShoppingCartProduct(Product product) {
    final entry = {
      "product": product,
      "quantity": 1,
    };

    final index = _shoppingCartProducts.indexWhere(
      (element) {
        return element["product"].id == product.id;
      },
    );

    if (index == -1) {
      _shoppingCartProducts.add(entry);
    } else {
      final map = _shoppingCartProducts[index];
      map["quantity"] = map["quantity"] + 1;
      _shoppingCartProducts[index] = map;
    }
  }

  void removeShoppingCartProduct(Product product) {
    final index = _shoppingCartProducts.indexWhere(
      (element) {
        return element["product"].id == product.id;
      },
    );

    if (index != -1) {
      final map = _shoppingCartProducts[index];
      map["quantity"] = map["quantity"] - 1;
      _shoppingCartProducts[index] = map;
    }
  }

  int getShoppingCartQuantity(Product product) {
    final index = _shoppingCartProducts.indexWhere(
      (element) {
        return element["product"].id == product.id;
      },
    );

    if (index == -1) {
      return 0;
    }

    final quantity = _shoppingCartProducts[index]["quantity"];
    log(quantity.toString());

    return quantity;
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
