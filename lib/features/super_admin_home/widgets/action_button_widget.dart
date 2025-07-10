import 'package:flutter/material.dart';

/// A reusable widget that displays Resolved and Reject action buttons
/// with a modal bottom sheet for rejection notes
class ActionButtonsWidget extends StatefulWidget {
  final VoidCallback? onResolved;
  final Function(String reason)? onRejected;
  final bool isRejectLoading;
  final bool isResolvedLoading;
  final String resolvedText;
  final String rejectText;
  final EdgeInsets? padding;
  final double? spacing;

  const ActionButtonsWidget({
    super.key,
    this.onResolved,
    this.onRejected,
    this.isResolvedLoading = false,
    this.isRejectLoading = false,
    this.resolvedText = 'Resolved',
    this.rejectText = 'Reject',
    this.padding,
    this.spacing,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  void _showRejectDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RejectBottomSheet(
        onSubmit: (reason) {
          Navigator.pop(context);
          widget.onRejected?.call(reason);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Resolved Button
          Expanded(
            child: FilledButton.icon(
              onPressed: widget.isResolvedLoading ? null : widget.onResolved,
              icon: widget.isResolvedLoading
                  ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
                  : const Icon(Icons.check_circle_outline),
              label: Text(widget.resolvedText),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          SizedBox(width: widget.spacing ?? 12),

          // Reject Button
          Expanded(
            child: FilledButton.icon(
              onPressed: widget.isRejectLoading ? null : _showRejectDialog,
              icon: const Icon(Icons.cancel_outlined),
              label: Text(widget.rejectText),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet widget for rejection note input
class RejectBottomSheet extends StatefulWidget {
  final Function(String reason) onSubmit;

  const RejectBottomSheet({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<RejectBottomSheet> createState() => _RejectBottomSheetState();
}

class _RejectBottomSheetState extends State<RejectBottomSheet> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call delay (remove in production)
    await Future.delayed(const Duration(milliseconds: 800));

    widget.onSubmit(_textController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: mediaQuery.viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Row(
            children: [
              Icon(
                Icons.report_problem_outlined,
                color: colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Rejection Reason',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Please provide a reason for rejecting this item. This information will be shared with the requester.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // Form
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _textController,
              maxLines: 4,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                labelText: 'Rejection reason',
                hintText: 'Enter your reason here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a rejection reason';
                }
                if (value.trim().length < 10) {
                  return 'Reason must be at least 10 characters long';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to update button state
              },
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton(
                  onPressed: (_textController.text.trim().isEmpty || _isSubmitting)
                      ? null
                      : _handleSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onError,
                      ),
                    ),
                  )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}