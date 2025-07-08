import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ErrorScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;

    final String errorType = data['errorType'] ?? 'unknown';
    final String message = data['message'] ?? 'An unexpected error occurred';
    final bool showLoginOption = data['showLoginOption'] ?? true;
    final bool showRetryOption = data['showRetryOption'] ?? false;
    final VoidCallback? onRetry = data['onRetry'];
    final VoidCallback? onContinueOffline = data['onContinueOffline'];

    switch (errorType) {
      case 'noInternet':
        icon = Icons.wifi_off;
        title = 'No Internet Connection';
        break;
      case 'serverError':
        icon = Icons.cloud_off;
        title = 'Server Error';
        break;
      case 'unexpectedError':
      default:
        icon = Icons.error_outline;
        title = 'Something Went Wrong';
        break;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Retry button
              if (showRetryOption && onRetry != null) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  },
                  child: const Text('Retry'),
                ),
                const SizedBox(height: 16),
              ],

              // Continue offline button
              if (onContinueOffline != null) ...[
                OutlinedButton(
                  onPressed: onContinueOffline,
                  child: const Text('Continue Offline'),
                ),
                const SizedBox(height: 16),
              ],

              // Go to login
              if (showLoginOption) ...[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false,
                    );
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
