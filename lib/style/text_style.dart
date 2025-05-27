import 'package:flutter/material.dart';
import 'theme/app_color.dart';

class AppTextStyles {
  static const regular = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static const semiBold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const bold = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Additional useful styles:
  static const appBarTitle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.textLight,
  );

  static const messageText = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const timestamp = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.complementary,
  );

  // ...existing code...

  static const button = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.textLight,
  );

  static const title = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: AppColors.primary,
  );
}
