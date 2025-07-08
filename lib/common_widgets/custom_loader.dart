import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks the column to its content
        mainAxisAlignment: MainAxisAlignment.center, // Vertical alignment
        children: [
          Lottie.asset(
            'assets/animations/loader.json',
            width: 60,
            // height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 5,),
          const Text('Loading...')
        ],
      ),
    );
  }
}