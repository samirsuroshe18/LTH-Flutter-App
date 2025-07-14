import 'package:flutter/material.dart';

class ReopenButton extends StatefulWidget {
  final Future<void> Function()? onReopen;
  final String buttonText;
  final String confirmationMessage;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool enabled;
  final bool isProcessing;

  const ReopenButton({
    super.key,
    this.onReopen,
    this.buttonText = 'Reopen',
    this.confirmationMessage = 'Are you sure you want to reopen this complaint?',
    this.buttonColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.enabled = true,
    this.isProcessing = false,
  });

  @override
  State<ReopenButton> createState() => _ReopenButtonState();
}

class _ReopenButtonState extends State<ReopenButton> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default button color (amber with blue-grey as fallback)
    final buttonColor = widget.buttonColor ??
        (theme.brightness == Brightness.light
            ? Colors.amber[700]
            : Colors.blueGrey[600]);

    final textColor = widget.textColor ??
        (theme.brightness == Brightness.light
            ? Colors.white
            : Colors.white);

    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.isProcessing ? null : widget.onReopen,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
        ),
        child: widget.isProcessing
            ? SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              size: 18.0,
              color: textColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.buttonText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}