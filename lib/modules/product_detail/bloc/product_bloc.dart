import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/modules/product_detail/bloc/product_event.dart';
import 'package:appcurso/modules/product_detail/bloc/product_state.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProduct>(_onFetchProduct);
    on<AddToCart>(_onAddToCart);
    on<AddToFavorite>(_onAddToFavorite);
    on<SelectSize>(_selectSize);
  }

  final ApiService apiService = ApiService();

  // dependencias
  final token = Get.find<LoginController>().userCredential?.jwt;
  final homeController = Get.find<HomeController>();

  Future<void> _onFetchProduct(
    FetchProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await apiService.getProduct(
        token: token!,
        productId: event.productId,
      );

      if (product == null) {
        emit(ProductError(error: "Error fetching product"));
        return;
      }

      _updateProduct(product, emit);
    } catch (e) {
      emit(ProductError(error: "Error fetching product"));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<ProductState> emit) {
    homeController.addShoppingCartProduct(event.product);
    _updateProduct(event.product, emit);
  }

  void _onAddToFavorite(AddToFavorite event, Emitter<ProductState> emit) {
    homeController.toggleFavoriteProduct(event.product);
    _updateProduct(event.product, emit);
  }

  void _selectSize(SelectSize event, Emitter<ProductState> emit) {
    final isFavorite = homeController.isFavoriteProduct(event.product);
    final cartCount =
        homeController.getShoppingCartProductQuantity(event.product);

    emit(
      ProductLoaded(
        product: event.product,
        isFavorite: isFavorite,
        selectedSize: event.size,
        shoppingCartProduct: {
          "product": event.product,
          "quantity": cartCount,
        },
      ),
    );
  }

  _updateProduct(Product product, Emitter<ProductState> emit) {
    final isFavorite = homeController.isFavoriteProduct(product);
    final cartCount = homeController.getShoppingCartProductQuantity(product);

    emit(
      ProductLoaded(
        product: product,
        isFavorite: isFavorite,
        selectedSize: state.selectedSize,
        shoppingCartProduct: {
          "product": product,
          "quantity": cartCount,
        },
      ),
    );
  }
}
