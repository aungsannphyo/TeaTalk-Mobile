import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';

class CommonAvatarWidget extends StatelessWidget {
  final String username;
  final String? profileImage; // Network image path
  final File? imageFile; // Local picked image file
  final double radius;

  const CommonAvatarWidget({
    super.key,
    required this.username,
    this.profileImage,
    this.imageFile,
    this.radius = 28,
  });

  String? get baseUrl => dotenv.env['API_URL'];

  bool get hasNetworkImage =>
      profileImage != null &&
      profileImage!.isNotEmpty &&
      profileImage!.toLowerCase() != 'null';

  static const List<Color> _bgColors = [
    Color(0xFFC9A66B),
    Color(0xFF8B5E3C),
    Color(0xFFD96C06),
  ];

  static const List<Color> _reservedThemeColors = [
    AppColors.primary,
    AppColors.accent,
    Colors.white,
  ];

  Color _getBackgroundColor() {
    final hash = username.codeUnits.fold(0, (sum, c) => sum + c);
    final filteredColors = _bgColors.where((color) {
      return !_reservedThemeColors
          .any((reserved) => _isColorTooSimilar(color, reserved));
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
    final brightness =
        (bgColor.r * 299 + bgColor.g * 587 + bgColor.b * 114) / 1000;
    return brightness > 150 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (hasNetworkImage && baseUrl != null) {
      imageProvider = NetworkImage('$baseUrl$profileImage');
    }

    final isShowingFallback = imageProvider == null;

    return Container(
      width: radius * 2 + 4,
      height: radius * 2 + 4,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor:
            isShowingFallback ? _getBackgroundColor() : Colors.grey[300],
        backgroundImage: imageProvider,
        child: isShowingFallback
            ? Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: AppTextStyles.semiBold.copyWith(
                  color: _getContrastingTextColor(_getBackgroundColor()),
                  fontSize: radius * 0.7,
                ),
              )
            : null,
      ),
    );
  }
}
