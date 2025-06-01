import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';

class PlaceholderWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool isSvg;

  const PlaceholderWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.isSvg,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSvg
                ? SvgPicture.asset(
                    imagePath,
                    height: 200,
                  )
                : Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    color: AppColors.accent,
                  ),
            SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular.copyWith(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
