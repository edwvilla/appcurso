import 'package:appcurso/models/product.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ShoppingCartEntry extends HiveObject {
  @HiveField(0)
  final int quantity;
  @HiveField(1)
  final Product product;

  ShoppingCartEntry({required this.quantity, required this.product});
}
