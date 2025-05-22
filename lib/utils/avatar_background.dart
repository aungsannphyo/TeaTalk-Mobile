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

String getRandomDefaultAvatar(String username) {
  final avatars = [
    'assets/images/avatar_traveler.svg',
    'assets/images/businesswoman_avatar.svg',
    'assets/images/developer_avatar.svg',
    'assets/images/finance_guy_avatar.svg',
    'assets/images/girl_avatar.svg',
    'assets/images/professional_woman_avatar.svg',
    'assets/images/woman_avatar.svg',
  ];

  final hash = username.codeUnits.fold(0, (sum, code) => sum + code);
  final index = hash % avatars.length;

  return avatars[index];
}
