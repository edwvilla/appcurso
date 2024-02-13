import 'dart:developer';
import 'package:appcurso/models/user_credential.dart';
import 'package:appcurso/modules/home/home_route.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> signIn(BuildContext context) async {
    isLoading.value = true;
    // validar los datos
    final String email = emailController.text;
    final String password = passwordController.text;
    final userCredentialBox = GetStorage();

    if (email.isEmpty || password.isEmpty) {
      log("email o password no recibidos");
      isLoading.value = false;
      return;
    }

    try {
      final UserCredential? userCredential = await ApiService().signIn(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        Get.off(const HomeRoute());
        await userCredentialBox.write("userCredential", userCredential);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
