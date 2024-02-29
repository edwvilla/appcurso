import 'dart:developer';

import 'package:appcurso/common/utils/utils.dart';
import 'package:appcurso/modules/product_detail/bloc/product_bloc.dart';
import 'package:appcurso/modules/product_detail/bloc/product_event.dart';
import 'package:appcurso/modules/product_detail/bloc/product_state.dart';
import 'package:appcurso/modules/product_detail/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductDetailRouteBloc extends StatelessWidget {
  const ProductDetailRouteBloc({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc()
        ..add(
          FetchProduct(productId: productId),
        ),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final bloc = context.read<ProductBloc>();

          switch (state.runtimeType) {
            case ProductInitial:
            case ProductLoading:
              return const _PorudctLoadingWidget();

            case ProductLoaded:
              state as ProductLoaded;
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
                      icon: state.isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                      onPressed: () {
                        bloc.add(AddToFavorite(product: state.product));
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
                        bloc.add(AddToCart(product: state.product));
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
                          state.shoppingCartProduct["quantity"].toString(),
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
                          tag: state.product.id,
                          child: Image.network(
                            state.product.attributes.imageUrl,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            state.product.attributes.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                            maxLines: 3,
                                          ),
                                        ),
                                        Text(
                                          "By ${state.product.attributes.brand}",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              priceFormat(state
                                                  .product.attributes.price),
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
                                              state.product.attributes.rating
                                                  .toString(),
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
                                    state.product.attributes.details.sizes
                                        .map((e) {
                                      final isSelected =
                                          state.selectedSize == e;

                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          backgroundColor: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                              color: Colors.black12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          bloc.add(
                                            SelectSize(
                                              size: e,
                                              product: state.product,
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
                                state.product.attributes.description,
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

            case ProductError:
              return const _ProductErrorWidget();

            default:
              return const _PorudctLoadingWidget();
          }
        },
      ),
    );
  }
}

class _PorudctLoadingWidget extends StatelessWidget {
  const _PorudctLoadingWidget({
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

class _ProductErrorWidget extends StatelessWidget {
  const _ProductErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error"),
    );
  }
}
