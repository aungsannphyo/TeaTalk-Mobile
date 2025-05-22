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
    'assets/images/male_avatar.svg',
    'assets/images/female_avatar.svg',
  ];

  final hash = username.codeUnits.fold(0, (sum, code) => sum + code);
  final index = hash % avatars.length;

  return avatars[index];
}
