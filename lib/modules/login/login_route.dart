import 'package:appcurso/modules/home/home_route.dart';
import 'package:appcurso/modules/login/controller/login_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginRoute extends StatelessWidget {
  LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(width: double.infinity),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Login to your account",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(
                "assets/login.svg",
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 20),
              // INPUTS

              CustomTextField(
                controller: controller.emailController,
                label: "Enter your email",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: controller.passwordController,
                label: "Enter your password",
                icon: Icons.lock_outlined,
                obscureText: true,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () => controller.signIn(context),
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
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  void initState() {
    showPassword = widget.obscureText;
    super.initState();
  }

  void toggleShowPassword() {
    showPassword = !showPassword;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && showPassword,
        decoration: InputDecoration(
          label: Text(widget.label),
          prefixIcon: Icon(widget.icon),
          prefixIconColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? Colors.green
                  : Colors.grey),
          suffixIcon: (widget.obscureText)
              ? InkWell(
                  onTap: toggleShowPassword,
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          suffixIconColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.focused)
                ? Colors.green
                : Colors.grey,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }
}
