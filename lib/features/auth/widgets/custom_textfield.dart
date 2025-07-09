import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String errorMsg;
  final Icon? icon;
  final bool obscureText;
  const CustomTextField({super.key, required this.hintText, required this.controller, required this.errorMsg, this.icon, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),

        ),
        fillColor: Colors.blue.withValues(alpha: 0.1),
        filled: true,
        prefixIcon: icon,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        return null;
      },
    );
  }
}
