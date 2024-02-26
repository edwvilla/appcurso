import 'package:appcurso/common/widgets/custom_text_field_widget.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:appcurso/modules/login/login_route.dart';
import 'package:appcurso/modules/register/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterRoute extends StatelessWidget {
  const RegisterRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(width: double.infinity),
                const Spacer(),
                const Text(
                  "Let's get started!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Create an account to get all features",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // INPUTS

                CustomTextField(
                  controller: controller.userNameController,
                  label: "Enter your username",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: controller.emailController,
                  label: "Enter your email",
                  icon: Icons.alternate_email,
                  validator: (value) {
                    if (!GetUtils.isEmail(value!)) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: controller.passwordController,
                  label: "Enter your password",
                  icon: Icons.lock_outlined,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: controller.confirmPasswordController,
                  label: "Confirm password",
                  icon: Icons.lock_outlined,
                  obscureText: true,
                  validator: (value) {
                    if (value != controller.passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => controller.signUp(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.offAll(() => const LoginRoute()),
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
