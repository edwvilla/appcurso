import 'package:appcurso/models/product.dart';
import 'package:appcurso/models/shopping_cart_entry.dart';
import 'package:appcurso/modules/login/login_route.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await GetStorage.init();
  await Hive.initFlutter();

  Hive.registerAdapter(ShoppingCartEntryAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(AttributesAdapter());
  Hive.registerAdapter(DetailsAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginRoute(),
    );
  }
}
