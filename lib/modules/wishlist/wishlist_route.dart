import 'package:appcurso/common/utils/utils.dart';
import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistRoute extends StatelessWidget {
  const WishlistRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      body: FutureBuilder<List<Product>>(
          future: FirestoreService().getFavorites(),
          builder: (context, snapshot) {
            // loader
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // error
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text("Wishlist not found"),
              );
            }

            final products = snapshot.data!;

            // empty
            if (products.isEmpty) {
              return const Center(
                child: Text("Your wishlist is empty."),
              );
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Dismissible(
                  key: Key(product.id.toString()),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      homeController.toggleFavoriteProduct(product);
                    }
                  },
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(product.attributes.imageUrl),
                    ),
                    title: Text(product.attributes.name),
                    subtitle:
                        Text("\$${priceFormat(product.attributes.price)}"),
                  ),
                );
              },
            );
          }),
    );
  }
}
