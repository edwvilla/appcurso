part of "product_bloc.dart";

abstract class ProductEvent {}

class FetchProduct extends ProductEvent {
  final int productId;

  FetchProduct({required this.productId});
}
