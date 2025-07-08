import 'package:flutter/material.dart';

import 'custom_cached_network_image.dart';

class CustomFullScreenImageViewer {
  static void show(BuildContext context, String? imageUrl, {IconData errorImage=Icons.person}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  panEnabled: true, // Allow panning
                  scaleEnabled: true, // Allow zooming
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: double.infinity,
                      minWidth: double.infinity,
                    ),
                    child: CustomCachedNetworkImage(
                      imageUrl: imageUrl ?? '',
                      isCircular: false,
                      borderWidth: 0,
                      fit: BoxFit.contain,
                      errorImage: errorImage,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}