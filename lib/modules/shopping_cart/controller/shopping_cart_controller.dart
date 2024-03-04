import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/models/shopping_cart_entry.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ShoppingCartController extends GetxController {
  final _shoppingCartProducts = <ShoppingCartEntry>[].obs;
  List<ShoppingCartEntry> get shoppingCartProducts => _shoppingCartProducts;

  static const String kShoppingCartBox = "shoppingCartBox";

  @override
  void onInit() {
    super.onInit();
    seedProducts();
  }

  void seedProducts() async {
    _shoppingCartProducts.value = await _loadProductsFromDB();
  }

  void addShoppingCartProduct(Product product) {
    final entry = ShoppingCartEntry(
      product: product,
    );

    final index = _shoppingCartProducts
        .indexWhere((element) => element.product == product);

    if (index == -1) {
      _shoppingCartProducts.add(entry);
      _saveProductDB(entry);
    } else {
      final ShoppingCartEntry entry = _shoppingCartProducts[index];
      final newEntry = entry.copyWith(quantity: entry.quantity + 1);
      _shoppingCartProducts[index] = newEntry;
      _updateEntryDB(newEntry);
    }
  }

  void removeShoppingCartProduct(Product product) {
    final index = _shoppingCartProducts
        .indexWhere((element) => element.product == product);

    if (index == -1) {
      return;
    }

    final ShoppingCartEntry entry = _shoppingCartProducts[index];
    if (entry.quantity > 1) {
      final newEntry = entry.copyWith(quantity: entry.quantity - 1);
      _shoppingCartProducts[index] = newEntry;
      _updateEntryDB(newEntry);
    } else {
      _shoppingCartProducts.removeAt(index);
      _removeProductDB(entry);
    }
  }

  int getShoppingCartProductQuantity(Product product) {
    final index = _shoppingCartProducts
        .indexWhere((element) => element.product == product);

    if (index == -1) {
      return 0;
    }

    final ShoppingCartEntry entry = _shoppingCartProducts[index];
    return entry.quantity;
  }

  Future<Box<ShoppingCartEntry>> get shoppingCartBox {
    return Hive.openBox<ShoppingCartEntry>(kShoppingCartBox);
  }

  // loadProducts
  Future<List<ShoppingCartEntry>> _loadProductsFromDB() async {
    final Box<ShoppingCartEntry> box = await shoppingCartBox;

    return List<ShoppingCartEntry>.from(box.values);
  }

  // save product

  Future<ShoppingCartEntry> _saveProductDB(ShoppingCartEntry entry) async {
    final Box<ShoppingCartEntry> box = await shoppingCartBox;

    try {
      await box.add(entry);
      return entry;
    } catch (e) {
      throw Exception("Item not found");
    }
  }

  // update product
  Future<ShoppingCartEntry> _updateEntryDB(ShoppingCartEntry entry) async {
    final Box<ShoppingCartEntry> box = await shoppingCartBox;

    try {
      final list = await _loadProductsFromDB();
      final index =
          list.indexWhere((element) => element.product == entry.product);
      await box.putAt(index, entry);
      return entry;
    } catch (e) {
      throw Exception("Item not found");
    }
  }

  // remove product
  Future<bool> _removeProductDB(ShoppingCartEntry entry) async {
    final Box<ShoppingCartEntry> box = await shoppingCartBox;

    try {
      final list = await _loadProductsFromDB();
      final index = list.indexOf(entry);
      await box.deleteAt(index);

      return true;
    } catch (e) {
      return false;
    }
  }
}
