import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../style/text_style.dart';
import '../../../../style/theme/app_color.dart';

class AvatarWidget extends StatelessWidget {
  final String? profileImage;
  final String username;
  final double radius;

  const AvatarWidget({
    super.key,
    required this.username,
    this.profileImage,
    this.radius = 28,
  });

  String? get baseUrl => dotenv.env['API_URL'];

  bool get hasValidImage =>
      profileImage != null &&
      profileImage!.isNotEmpty &&
      profileImage!.toLowerCase() != 'null';

  static const List<Color> _bgColors = [
    Color(0xFFC9A66B), // Light caramel
    Color(0xFF8B5E3C), // Tea brown
    Color(0xFFD96C06), // Bright accent (orange-ish)
  ];

  static const List<Color> _reservedThemeColors = [
    AppColors.primary,
    AppColors.accent,
    Colors.white, // Assuming white is your background
  ];

  Color _getBackgroundColor() {
    final hash = username.codeUnits.fold(0, (sum, c) => sum + c);
    final filteredColors = _bgColors.where((color) {
      final isSimilar = _reservedThemeColors
          .any((reserved) => _isColorTooSimilar(color, reserved));
      return !isSimilar;
    }).toList();

    final safeColors = filteredColors.isNotEmpty ? filteredColors : _bgColors;

    return safeColors[hash % safeColors.length];
  }

  bool _isColorTooSimilar(Color c1, Color c2, {double threshold = 0.1}) {
    return (c1.r - c2.r).abs() < threshold &&
        (c1.g - c2.g).abs() < threshold &&
        (c1.b - c2.b).abs() < threshold;
  }

  Color _getContrastingTextColor(Color bgColor) {
    // Calculate brightness (0 = dark, 255 = bright)
    final brightness =
        (bgColor.r * 299 + bgColor.g * 587 + bgColor.b * 114) / 1000;
    return brightness > 150 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (hasValidImage && baseUrl != null) {
      return Container(
        width: radius * 2 + 4, // 2px border on each side
        height: radius * 2 + 4,
        padding: const EdgeInsets.all(2), // Border width
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage('$baseUrl$profileImage'),
          backgroundColor: Colors.grey[300],
        ),
      );
    }

    final bgColor = _getBackgroundColor();
    final fontColor = _getContrastingTextColor(bgColor);
    final firstChar = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        firstChar,
        style: AppTextStyles.semiBold.copyWith(
          color: fontColor,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
