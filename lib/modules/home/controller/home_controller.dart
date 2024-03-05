import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:appcurso/services/firestore_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final apiService = ApiService();
  final firestoreService = FirestoreService();
  final LoginController loginController = Get.find<LoginController>();

  final _selectedPage = 0.obs;

  changePage(int index) {
    _selectedPage.value = index;
  }

  RxInt get currentPage => _selectedPage;

  final _favoriteProducts = <Product>[].obs;

  List<Product> get favoriteProducts => _favoriteProducts;

  @override
  void onInit() {
    super.onInit();
    loadFavoritesFromFirestore();
  }

  void loadFavoritesFromFirestore() async {
    final List<Product> favorites = await FirestoreService().getFavorites();
    _favoriteProducts.value = favorites;
  }

  void toggleFavoriteProduct(Product product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
      firestoreService.deleteFavorite(product);
    } else {
      _favoriteProducts.add(product);
      firestoreService.createFavorite(product);
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
