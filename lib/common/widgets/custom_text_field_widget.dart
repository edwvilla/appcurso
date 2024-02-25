import 'package:flutter/material.dart';

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
