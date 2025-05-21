import 'dart:ui';

import '../style/theme/app_color.dart';

Color avatarBackground(String name) {
  final code = name.isNotEmpty ? name.codeUnitAt(0) : 65;
  final colors = [
    AppColors.primary,
    AppColors.complementary,
    AppColors.accent,
  ];
  return colors[code % colors.length];
}
