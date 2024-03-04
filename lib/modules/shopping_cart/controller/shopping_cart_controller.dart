import 'package:appcurso/models/product.dart';
import 'package:get/get.dart';

class ShoppingCartController extends GetxController {
  final _shoppingCartProducts = <Map>[].obs;
  List<Map> get shoppingCartProducts => _shoppingCartProducts;

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
}
