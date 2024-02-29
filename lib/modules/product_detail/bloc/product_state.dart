part of "product_bloc.dart";

abstract class ProductState {}

class ProductIdle extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final Product product;
  final double selectedSize;
  final int quantity;

  ProductSuccess({
    required this.product,
    this.selectedSize = 0,
    this.quantity = 0,
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
