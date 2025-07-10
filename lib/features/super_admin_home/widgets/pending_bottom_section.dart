import 'package:flutter/material.dart';

class PendingBottomSection extends StatelessWidget {
  final VoidCallback onIsResolved;
  final bool isActionLoading;
  const PendingBottomSection({super.key, required this.onIsResolved, required this.isActionLoading,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: isActionLoading ? null : onIsResolved,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.deepPurple.withAlpha(128), // .withValues(alpha: 0.5) is not valid, use withAlpha
            ),
            child: isActionLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
                : const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'Mark as Resolved',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
