import 'package:appcurso/models/product.dart';

abstract class ProductEvent {}

class FetchProduct extends ProductEvent {
  FetchProduct({required this.productId});

  final int productId;
}

class AddToCart extends ProductEvent {
  AddToCart({required this.product});

  final Product product;
}

class AddToFavorite extends ProductEvent {
  AddToFavorite({required this.product});

  final Product product;
}

class SelectSize extends ProductEvent {
  SelectSize({required this.size, required this.product});

  final double size;
  final Product product;
}
