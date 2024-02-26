import 'package:appcurso/models/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded({
    required this.product,
    this.isFavorite = false,
    this.shoppingCartProduct = const {},
  });

  final Product product;
  final bool isFavorite;
  final Map shoppingCartProduct;
}

class ProductError extends ProductState {
  ProductError({required this.error});

  final String error;
}
