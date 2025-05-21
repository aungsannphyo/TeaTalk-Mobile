import 'package:flutter/material.dart';

import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';

class CommonElevateButtonWidget extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  const CommonElevateButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.semiBold.copyWith(
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
