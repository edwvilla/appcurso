import 'package:appcurso/models/product.dart';
import 'package:hive/hive.dart';

part "shopping_cart_entry.g.dart";

@HiveType(typeId: 0)
class ShoppingCartEntry extends HiveObject {
  @HiveField(0)
  final int quantity;
  @HiveField(1)
  final Product product;

  ShoppingCartEntry copyWith({
    int? quantity,
    Product? product,
  }) {
    return ShoppingCartEntry(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }

  ShoppingCartEntry({this.quantity = 1, required this.product});
}
