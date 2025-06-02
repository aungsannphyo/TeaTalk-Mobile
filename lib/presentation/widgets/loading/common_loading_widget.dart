import 'package:flutter/material.dart';

import '../../../style/text_style.dart';
import 'dot_animation_widget.dart';

class CommonLoadingWidget extends StatelessWidget {
  final Color backgroundColor;

  const CommonLoadingWidget({
    super.key,
    this.backgroundColor = Colors.black54, // Overlay color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor, // Fullscreen semi-transparent background
      child: Center(
        child: Container(
          width: 150,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).round()),
                blurRadius: 8,
              )
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Loading",
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 24),
                const DotAnimationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
