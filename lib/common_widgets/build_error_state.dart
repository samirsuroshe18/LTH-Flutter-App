import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuildErrorState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final double kToolbarCount;
  const BuildErrorState({super.key, required this.onRefresh, this.kToolbarCount = 3});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - (kToolbarHeight*kToolbarCount),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/error.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "Something went wrong!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
