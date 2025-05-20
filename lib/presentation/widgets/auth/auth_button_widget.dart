import 'package:flutter/material.dart';

import '../../../style/theme/color.dart';
import '../../../style/text_style.dart';

class AuthButtonWidget extends StatelessWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  const AuthButtonWidget({
    super.key,
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(label,
                style: AppTextStyles.semiBold.copyWith(color: Colors.white)),
      ),
    );
  }
}
