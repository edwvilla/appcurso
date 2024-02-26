import 'package:flutter/material.dart';

class ShoppingCartRoute extends StatelessWidget {
  const ShoppingCartRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: const Center(
        child: Text("Shopping Cart"),
      ),
    );
  }
}
