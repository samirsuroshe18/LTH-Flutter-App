import 'package:flutter/material.dart';

class AuthBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthBtn({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      height: 60, // Dynamic height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4286f4), // Light Blue
            Color(0xFF373B44), // Darker Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Keep it transparent for gradient
          shadowColor: Colors.transparent, // No extra shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? LayoutBuilder(
          builder: (context, constraints) {
            double size = constraints.maxHeight * 0.99; // 60% of button height
            return SizedBox(
              width: size,
              height: size,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              ),
            );
          },
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
