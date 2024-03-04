import 'package:appcurso/common/utils/utils.dart';
import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/product_detail/product_detail_route.dart';
import 'package:appcurso/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final shoppingCartController = Get.find<ShoppingCartController>();

    return InkWell(
      onTap: () => Get.to(
        () => ProductDetailRoute(productId: product.id),
      ),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Obx(() {
                  final isFavorite = homeController.isFavoriteProduct(product);

                  return SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          homeController.toggleFavoriteProduct(product),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  );
                }),
              ),
              Center(
                child: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.attributes.imageUrl,
                    height: 75,
                    width: 100,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                product.attributes.name,
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Text(
                                "\$",
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            Text(
                              priceFormat(product.attributes.price),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                        RatingBarIndicator(
                          rating: product.attributes.rating.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          unratedColor: Colors.grey[50],
                          itemCount: 5,
                          itemSize: 15.0,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () {
                      final quantity = shoppingCartController
                          .getShoppingCartProductQuantity(product);
                      return quantity > 0
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: InkWell(
                                      onTap: () => shoppingCartController
                                          .removeShoppingCartProduct(product),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: InkWell(
                                      onTap: () => shoppingCartController
                                          .addShoppingCartProduct(product),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 25,
                              width: 25,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent[100],
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () => shoppingCartController
                                    .addShoppingCartProduct(product),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
