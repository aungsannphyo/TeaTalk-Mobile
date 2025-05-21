import 'package:flutter/material.dart';

import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';
import 'app_drawer_header.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String? profileImageUrl;

  const AppDrawer({
    super.key,
    required this.username,
    required this.email,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDrawerHeader(
            username: username,
            email: email,
            initial: initial,
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
              color: AppColors.textDark,
            ),
            title: Text(
              'My Profile',
              style: AppTextStyles.semiBold,
            ),
            onTap: () {
              // Navigate to profile or trigger action
            },
          ),
          const Divider(color: AppColors.bubbleShadow),
        ],
      ),
    );
  }
}
