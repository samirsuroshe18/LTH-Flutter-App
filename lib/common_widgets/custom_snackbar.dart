import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String? message,
    required SnackBarType type,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF28A745); // Green
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFFD32F2F); // Red
        icon = Icons.error;
        break;
      case SnackBarType.info:
        backgroundColor = const Color(0xFF1976D2); // Blue
        icon = Icons.info;
        break;
    }

    final snackBar = SnackBar(
      elevation: 0, // No shadow
      backgroundColor: Colors.transparent, // Transparent to blend with gradient
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.9), // Semi-transparent effect
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message ?? 'message not available',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

enum SnackBarType { success, error, info }
