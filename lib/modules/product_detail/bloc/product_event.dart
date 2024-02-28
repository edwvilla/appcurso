part of "product_bloc.dart";

abstract class ProductEvent {}

class FetchProduct extends ProductEvent {
  final int productId;

  FetchProduct({required this.productId});
}

class AddToFavorite extends ProductEvent {
  final Product product;

  AddToFavorite({required this.product});
}

class SelectSize extends ProductEvent {
  final double size;

  SelectSize({required this.size});
}

class AddToCart extends ProductEvent {
  final int quantity;
  final Product product;

  AddToCart({required this.quantity, required this.product});
}

class ResetProductState extends ProductEvent {}
