import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginRoute extends StatelessWidget {
  LoginRoute({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.greenAccent),
                  ),
                ),
              ),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
