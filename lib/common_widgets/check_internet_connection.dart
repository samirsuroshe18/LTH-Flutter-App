import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  bool isConnected = false;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    // Store subscription so we can cancel it
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      updateStatus(results);
    });

    checkInternet(); // Check at app start
  }

  void checkInternet() async {
    var results = await Connectivity().checkConnectivity();
    updateStatus(results);
  }

  void updateStatus(List<ConnectivityResult> results) {
    final connection = !results.contains(ConnectivityResult.none);

    // Only call setState or navigate if the widget is still mounted
    if (!mounted) return;

    setState(() {
      isConnected = connection;
    });

    if (isConnected) {
      // Delay a little to allow animation and avoid quick rebuild issues
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  isConnected
                      ? 'assets/animations/wifi_connected.json'
                      : 'assets/animations/no_internet.json',
                  width: 240,
                  height: 240,
                ),

                const SizedBox(height: 24),

                Text(
                  isConnected ? "Connected" : "No Internet",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isConnected ? Colors.lightBlue : Colors.red.shade600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isConnected
                      ? "You're online now"
                      : "Check your network connection",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 32),

                if (!isConnected)
                  ElevatedButton(
                    onPressed: checkInternet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(120, 36),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Check Again',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
