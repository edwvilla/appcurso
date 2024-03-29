import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/home/widgets/product_card_widget.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/modules/shopping_cart/controller/shopping_cart_controller.dart';
import 'package:appcurso/modules/shopping_cart/shopping_cart_route.dart';
import 'package:appcurso/modules/wishlist/wishlist_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final ShoppingCartController shoppingCartController =
        Get.put(ShoppingCartController());

    final LoginController loginController = Get.find<LoginController>();

    final pages = [
      const _HomeContent(),
      const WishlistRoute(),
      const ShoppingCartRoute(),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_basket_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () {
              Get.to(() => const ShoppingCartRoute());
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              loginController.signOut();
            },
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentPage.value,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_rounded),
              label: "Cart",
            ),
          ],
        ),
      ),
      body: Obx(() => pages[controller.currentPage.value]),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return SafeArea(
      child: FutureBuilder(
          future: controller.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Center(
                child: Text("No hay datos"),
              );
            }

            final List<Product> productList = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: GridView.builder(
                itemCount: productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4, // height / width
                ),
                itemBuilder: (ctx, index) => ProductCard(
                  product: productList[index],
                ),
              ),
            );
          }),
    );
  }
}
