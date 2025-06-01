import 'package:flutter/material.dart';
import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';
import '../screens/friend/widget/avatar_widget.dart';

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
          AvatarWidget(
            username: username,
            profileImage: profileImageUrl,
            radius: 35,
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
