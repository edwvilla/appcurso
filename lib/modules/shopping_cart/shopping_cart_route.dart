import 'dart:developer';

import 'package:appcurso/common/utils/utils.dart';
import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingCartRoute extends StatelessWidget {
  const ShoppingCartRoute({Key? key}) : super(key: key);

// ListView.builder
// 	ListTile
// 		Row
// 			Image
// 			Column
// 				Text title
// 				Text size
// 				Row
// 					Container addToCart quantity removeFromCart
// 					Text price

  @override
  Widget build(BuildContext context) {
    final shoppingCartController = Get.find<ShoppingCartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: Obx(
        () {
          final products = shoppingCartController.shoppingCartProducts;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index]["product"] as Product;

              return Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Row(
                  children: [
                    // Imagen
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        product.attributes.imageUrl,
                        height: 140,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Content
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.attributes.name,
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              "Size: 20",
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "\$${priceFormat(product.attributes.price)}",
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Obx(
                              () {
                                final controllerQuantity =
                                    shoppingCartController
                                        .getShoppingCartProductQuantity(
                                            product);

                                return Row(
                                  children: [
                                    // Botones

                                    IconButton(
                                      onPressed: () {
                                        shoppingCartController
                                            .removeShoppingCartProduct(product);
                                      },
                                      icon: controllerQuantity > 1
                                          ? const Icon(Icons.remove)
                                          : const Icon(Icons.delete_outline),
                                    ),

                                    Text(controllerQuantity.toString()),

                                    IconButton(
                                      onPressed: () {
                                        shoppingCartController
                                            .addShoppingCartProduct(product);
                                      },
                                      icon: const Icon(Icons.add),
                                    ),

                                    const Spacer(),

                                    // Price

                                    Text(
                                      "\$${priceFormat((product.attributes.price * controllerQuantity))}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
