import 'package:appcurso/models/product.dart';

abstract class ProductState {
  final Product? product;
  final bool isFavorite;
  final Map shoppingCartProduct;
  final double selectedSize;

  ProductState({
    this.product,
    this.isFavorite = false,
    this.shoppingCartProduct = const {},
    this.selectedSize = 0,
  });
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded({
    required this.product,
    this.isFavorite = false,
    this.shoppingCartProduct = const {},
    this.selectedSize = 0,
  });

  final Product product;
  final bool isFavorite;
  final Map shoppingCartProduct;
  final double selectedSize;
}

class ProductError extends ProductState {
  ProductError({required this.error});

  final String error;
}
