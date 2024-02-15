import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
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

            return GridView.builder(
              itemCount: productList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (ctx, index) {
                log("index $index");
                final Product product = productList[index];
                return Column(
                  children: [
                    Image.network(
                      product.attributes.imageUrl,
                      height: 80,
                      width: 80,
                    ),
                    Text(product.attributes.name),
                  ],
                );
              },
            );
          }),
    );
  }
}
