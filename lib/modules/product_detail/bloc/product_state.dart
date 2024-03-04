part of "product_bloc.dart";

abstract class ProductState {
  final Product? product;
  final double selectedSize;
  final int quantity;
  final bool isFavorite;

  ProductState({
    this.product,
    this.selectedSize = 0,
    this.quantity = 0,
    this.isFavorite = false,
  });
}

class ProductIdle extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  ProductSuccess({
    required super.product,
    super.selectedSize = 0,
    super.quantity = 0,
    super.isFavorite = false,
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
