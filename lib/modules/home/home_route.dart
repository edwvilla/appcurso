import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:appcurso/modules/home/inherited/api_inherited.dart';
import 'package:appcurso/modules/home/inherited/counter_inherited.dart';
import 'package:appcurso/modules/home/widgets/product_card_widget.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/modules/shopping_cart/shopping_cart_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiInherited(
      child: CounterInheritedNotifier(
        notifier: CounterNotifier(),
        child: const _HomeContent(),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final LoginController loginController = Get.find<LoginController>();

    final apiInherited = ApiInherited.of(context);

    apiInherited?.apiService
        .getProducts(
      token: loginController.userCredential?.jwt ?? "",
    )
        .then(
      (value) {
        log(value.toString());
      },
    );

    final counterInherited = CounterInheritedNotifier.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterInherited?.notifier?.increment();
        },
        child: Text(counterInherited?.notifier?.value.toString() ?? ""),
      ),
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
      body: SafeArea(
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
      ),
    );
  }
}
