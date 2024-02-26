import 'dart:developer';
import 'package:appcurso/models/user_credential.dart';
import 'package:appcurso/modules/home/home_route.dart';
import 'package:appcurso/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userCredentialBox = GetStorage();

  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  Future<void> signUp(BuildContext context) async {
    isLoading.value = true;
    // validar los datos
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final String userName = userNameController.text;

    if (password != confirmPassword) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: const Text("Las contraseñas no coinciden"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      log("email, password o confirmPassword no recibidos");
      isLoading.value = false;
      return;
    }

    try {
      final UserCredential? userCredential = await ApiService().signUp(
        userName: userName,
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
