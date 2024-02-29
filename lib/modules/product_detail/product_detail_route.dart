import 'dart:developer';

import 'package:appcurso/common/utils/utils.dart';
import 'package:appcurso/models/product.dart';
import 'package:appcurso/modules/product_detail/bloc/product_bloc.dart';
import 'package:appcurso/modules/product_detail/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductDetailRoute extends StatelessWidget {
  const ProductDetailRoute({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) =>
          ProductBloc()..add(FetchProduct(productId: productId)),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (BuildContext context, ProductState state) {
          switch (state.runtimeType) {
            case ProductIdle:
            case ProductLoading:
              return const _ProductLoading();

            case ProductSuccess:
              state as ProductSuccess;
              return _ProductLoaded(product: state.product);

            case ProductError:
            default:
              return const _ProductError();
          }
        },
      ),
    );
  }
}

class _ProductError extends StatelessWidget {
  const _ProductError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error"),
    );
  }
}

class _ProductLoaded extends StatelessWidget {
  const _ProductLoaded({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ProductController>();
    final productBloc = context.read<ProductBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: false
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  ),
            onPressed: () {
              // controller.addToFavorite(controller.product);
            },
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              productBloc.add(AddToCart(product: product));
            },
            backgroundColor: Colors.redAccent,
            child: const Icon(
              Icons.shopping_basket_rounded,
              color: Colors.white,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.shade200,
                shape: BoxShape.circle,
              ),
              child: Text(
                (productBloc.state as ProductSuccess).quantity.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: product.id,
                child: Image.network(
                  product.attributes.imageUrl,
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),

              // Details
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  product.attributes.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  maxLines: 3,
                                ),
                              ),
                              Text(
                                "By ${product.attributes.brand}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Text(
                                      "\$",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    priceFormat(product.attributes.price),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    product.attributes.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        const Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const FittedBox(),
                        ...List.from(
                          product.attributes.details.sizes.map((e) {
                            final state = productBloc.state as ProductSuccess;
                            final isSelected = state.selectedSize == e;

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                backgroundColor:
                                    isSelected ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                productBloc.add(
                                  SelectSize(
                                    size: e,
                                    product: product,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(),
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    // Description
                    const SizedBox(height: 20),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.attributes.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductLoading extends StatelessWidget {
  const _ProductLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
