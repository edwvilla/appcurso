import 'dart:async';
import 'dart:developer';

import 'package:appcurso/models/product.dart';
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

  _fetchProduct(FetchProduct event, Emitter<ProductState> emit) async {
    log("event $event, produt id ${event.productId}");

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

  FutureOr<void> _addToCart(AddToCart event, Emitter<ProductState> emit) {
    shoppingCartController.addShoppingCartProduct(event.product);
    final quantity =
        shoppingCartController.getShoppingCartProductQuantity(event.product);

    emit(
      ProductSuccess(
        product: event.product,
        quantity: quantity,
      ),
    );
  }

  FutureOr<void> _removeFromCart(
      RemoveFromCart event, Emitter<ProductState> emit) {}

  FutureOr<void> _addToFavorite(
      AddToFavorite event, Emitter<ProductState> emit) {}

  FutureOr<void> _removeFromFavorite(
      RemoveFromFavorite event, Emitter<ProductState> emit) {}

  FutureOr<void> _selectSize(SelectSize event, Emitter<ProductState> emit) {
    emit(
      ProductSuccess(
        product: event.product,
        selectedSize: event.size,
      ),
    );
  }
}
