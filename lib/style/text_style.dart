import 'package:flutter/material.dart';
import './theme/color.dart';

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
}
