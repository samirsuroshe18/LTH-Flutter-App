import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DataNotFoundWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData? customIcon;
  final String? animationAsset;
  final double kToolbarCount;
  final EdgeInsets? padding;
  final bool showRefreshButton;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final Color? primaryColor;
  final double animationSize;

  const DataNotFoundWidget({
    super.key,
    required this.onRefresh,
    this.title = 'No Data Found',
    this.subtitle = 'There\'s nothing to display right now. Pull down to refresh or try again.',
    this.buttonText = 'Refresh',
    this.customIcon,
    this.animationAsset = 'assets/animations/no_data.json',
    this.kToolbarCount = 3,
    this.padding,
    this.showRefreshButton = true,
    this.onSecondaryAction,
    this.secondaryActionText,
    this.primaryColor,
    this.animationSize = 200,
  });

  @override
  State<DataNotFoundWidget> createState() => _DataNotFoundWidgetState();
}

class _DataNotFoundWidgetState extends State<DataNotFoundWidget> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Color get _primaryColor {
    return widget.primaryColor ?? Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: _primaryColor,
      backgroundColor: colorScheme.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                (kToolbarHeight * widget.kToolbarCount),
          ),
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animation or Icon
                  _buildVisualElement(colorScheme),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    widget.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  _buildActionButtons(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualElement(ColorScheme colorScheme) {
    if (widget.animationAsset != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        padding: const EdgeInsets.all(24),
        child: Lottie.asset(
          widget.animationAsset!,
          width: widget.animationSize,
          height: widget.animationSize,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      );
    } else if (widget.customIcon != null) {
      return Container(
        width: widget.animationSize,
        height: widget.animationSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          widget.customIcon,
          size: widget.animationSize * 0.4,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      return Container(
        width: widget.animationSize,
        height: widget.animationSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.inbox_outlined,
          size: widget.animationSize * 0.4,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        // Primary refresh button
        if (widget.showRefreshButton)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isRefreshing ? null : _handleRefresh,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: _isRefreshing
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
                  : const Icon(Icons.refresh_rounded),
              label: Text(
                _isRefreshing ? 'Refreshing...' : widget.buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

        // Secondary action button (optional)
        if (widget.onSecondaryAction != null && widget.secondaryActionText != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onSecondaryAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryColor,
                side: BorderSide(color: _primaryColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.secondaryActionText!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
