import 'dart:async';
import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part "product_event.dart";
part "product_state.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductIdle()) {
    on<FetchProduct>(_fetchProduct);
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<AddToFavorite>(_addToFavorite);
    on<RemoveFromFavorite>(_removeFromFavorite);
    on<SelectSize>(_selectSize);
  }

  // dependencias
  final apiService = ApiService();
  final loginController = Get.find<LoginController>();
  final shoppingCartController = Get.find<ShoppingCartController>();
  final homeController = Get.find<HomeController>();

  _fetchProduct(FetchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final String? token = loginController.userCredential?.jwt;

    if (token == null) {
      emit(ProductError(message: "User not authenticated"));
    }

    final product = await apiService.getProduct(
      token: token!,
      productId: event.productId,
    );

    if (product == null) {
      emit(ProductError(message: "Product not found"));
    } else {
      emit(ProductSuccess(product: product));
    }
  }

  _updateProduct(Product product, Emitter<ProductState> emit, [double? size]) {
    final quantity =
        shoppingCartController.getShoppingCartProductQuantity(product);
    final isFavorite = homeController.isFavoriteProduct(product);

    emit(
      ProductSuccess(
        product: product,
        quantity: quantity,
        isFavorite: isFavorite,
        selectedSize: size ?? state.selectedSize,
      ),
    );
  }

  FutureOr<void> _addToCart(AddToCart event, Emitter<ProductState> emit) {
    shoppingCartController.addShoppingCartProduct(event.product);
    _updateProduct(event.product, emit);
  }

  FutureOr<void> _removeFromCart(
      RemoveFromCart event, Emitter<ProductState> emit) {
    shoppingCartController.removeShoppingCartProduct(event.product);
    _updateProduct(event.product, emit);
  }

  FutureOr<void> _addToFavorite(
      AddToFavorite event, Emitter<ProductState> emit) {
    homeController.toggleFavoriteProduct(event.product);
    _updateProduct(event.product, emit);
  }

  FutureOr<void> _removeFromFavorite(
      RemoveFromFavorite event, Emitter<ProductState> emit) {
    homeController.toggleFavoriteProduct(event.product);
    _updateProduct(event.product, emit);
  }

  FutureOr<void> _selectSize(SelectSize event, Emitter<ProductState> emit) {
    _updateProduct(event.product, emit, event.size);
  }
}
