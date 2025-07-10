import 'package:flutter/material.dart';

class ResolvedBottomSection extends StatelessWidget {
  final VoidCallback onReopen;
  final bool isActionLoading;
  const ResolvedBottomSection({
    super.key,
    required this.onReopen,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(51), // 0.2 * 255 ≈ 51
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: isActionLoading ? null : onReopen,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isActionLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            strokeWidth: 2,
          ),
        )
            : const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              'Reopen Complaint',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}