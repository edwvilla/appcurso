import 'dart:developer';

import 'package:appcurso/models/product.dart';
import 'package:appcurso/models/user_credential.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl =
      "https://polar-plains-89142-ae7bf2bd796a.herokuapp.com/";
  static const String signInPath = "api/auth/local";
  static const String signUpPath = "api/auth/local/register";
  static const String productsPath = "api/products";

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Dio().post(
        "$baseUrl$signInPath",
        data: {
          "identifier": email,
          "password": password,
        },
      );
      // serializar UserCredential
      final userCredential = UserCredential.fromJson(result.data);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final result = await Dio().post(
        "$baseUrl$signUpPath",
        data: {
          "username": userName,
          "email": email,
          "password": password,
        },
      );
      // serializar UserCredential
      final userCredential = UserCredential.fromJson(result.data);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  // GET PRODUCTS
  Future<List<Product>?> getProducts({
    required String token,
  }) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      final request = await Dio().get(
        "$baseUrl$productsPath",
        options: Options(
          headers: headers,
        ),
      );

      final list = request.data["data"];
      final productList = productsFromJson(list);

      return productList;
    } catch (e) {
      log(e.toString());

      return null;
    }
  }

  // GET PRODUCT
  Future<Product?> getProduct({
    required String token,
    required int productId,
  }) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      final request = await Dio().get(
        "$baseUrl$productsPath/$productId",
        options: Options(
          headers: headers,
        ),
      );

      final product = Product.fromJson(request.data["data"]);

      log(product.toString());

      return product;
    } catch (e) {
      log(e.toString());

      return null;
    }
  }
}
