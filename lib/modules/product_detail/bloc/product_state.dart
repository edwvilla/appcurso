part of "product_bloc.dart";

abstract class ProductState {}

class ProductIdle extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final Product product;

  ProductSuccess({required this.product});
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
