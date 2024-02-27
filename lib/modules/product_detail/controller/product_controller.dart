import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductController({required this.productId});
  final int productId;

  late final Product product;
  ProductDetailState state = ProductDetailState.idle;
  final homeController = Get.find<HomeController>();

  bool isFavorite = false;
  int cartCount = 0;

  double _selectedSize = 0;

  double get selectedSize => _selectedSize;

  set selectedSize(double value) {
    _selectedSize = value;
    update();
  }

  bool isSizeSelected(double index) => index == _selectedSize;

  void updateFavoriteStatus() {
    isFavorite = homeController.isFavoriteProduct(product);
    update();
  }

  void updateCartCount() {
    cartCount = homeController.getShoppingCartQuantity(product);
    update();
    log("Cart count: $cartCount");
  }

  @override
  void onInit() {
    super.onInit();
    getProduct(productId).then((value) {
      updateFavoriteStatus();
      updateCartCount();
    });
  }

  Future<void> getProduct(int id) async {
    state = ProductDetailState.loading;
    update();
    final token = Get.find<LoginController>().userCredential?.jwt;
    if (token == null) {
      state = ProductDetailState.error;
      update();
      return;
    }

    try {
      final response = await ApiService().getProduct(
        productId: id,
        token: token,
      );
      if (response == null) {
        state = ProductDetailState.error;
        update();
        return;
      } else {
        product = response;
        state = ProductDetailState.loaded;
      }
    } catch (e) {
      state = ProductDetailState.error;
    }

    update();
  }

  void addToFavorite(Product product) {
    homeController.toggleFavoriteProduct(product);
    updateFavoriteStatus();
  }

  void addToCart(Product product) {
    homeController.addShoppingCartProduct(product);
    updateCartCount();
  }
}

enum ProductDetailState {
  idle,
  loading,
  loaded,
  error,
}
