import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StaggeredListAnimation extends StatelessWidget {
  final int index;
  final Widget child;
  const StaggeredListAnimation({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 80.0,
        curve: Curves.easeOutBack, // Adds a nice bounce slide
        child: FadeInAnimation(
          child: ScaleAnimation(
            scale: 0.9,
            curve: Curves.easeOutBack, // Bounce zoom-in
            child: child,
          ),
        ),
      ),
    );
  }
}
