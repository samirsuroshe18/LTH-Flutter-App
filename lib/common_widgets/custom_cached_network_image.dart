import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final bool isCircular;
  final double size;
  final BoxFit fit;
  final double borderWidth;
  final Color borderColor;
  final IconData errorImage;
  final VoidCallback? onTap;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.isCircular = false,
    this.size = 100,
    this.fit = BoxFit.cover,
    this.borderWidth = 4,
    this.borderColor = Colors.white70,
    this.errorImage = Icons.error,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          color: Colors.grey,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: imageUrl!= null && imageUrl!.isNotEmpty
            ? Image.asset(imageUrl!, width: size * 0.8, height: size * 0.8,)
            : Icon(errorImage, size: size * 0.8),
      ),
    );

    return isCircular ? Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(), // ensure the ripple is circular
        child: ClipOval(child: imageWidget),
      ),
    ) : Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(), // ensure the ripple is circular
        child: imageWidget,
      ),
    );
  }
}