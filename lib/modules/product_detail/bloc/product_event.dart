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

class RemoveFromFavorite extends ProductEvent {
  final Product product;

  RemoveFromFavorite({required this.product});
}

class SelectSize extends ProductEvent {
  final double size;
  final Product product;

  SelectSize({required this.size, required this.product});
}

class AddToCart extends ProductEvent {
  final int quantity;
  final Product product;

  AddToCart({this.quantity = 1, required this.product});
}

class RemoveFromCart extends ProductEvent {
  final int quantity;
  final Product product;

  RemoveFromCart({required this.quantity, required this.product});
}
