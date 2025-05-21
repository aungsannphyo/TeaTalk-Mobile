import 'package:flutter/material.dart';

import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';

class AppDrawerHeader extends StatelessWidget {
  final String username;
  final String email;
  final String? profileImageUrl;
  final String initial;

  const AppDrawerHeader({
    super.key,
    required this.username,
    required this.email,
    this.profileImageUrl,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.complementary,
            backgroundImage:
                profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
            child: profileImageUrl == null
                ? Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            username,
            style: AppTextStyles.bold.copyWith(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          Text(
            email,
            style: AppTextStyles.regular.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
