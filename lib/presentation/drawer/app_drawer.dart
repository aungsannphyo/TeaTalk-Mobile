import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';
import '../providers/auth/login_provider.dart';
import 'app_drawer_header.dart';

class AppDrawer extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.dangerDark,
            ),
            title: Text(
              'Logout',
              style: AppTextStyles.semiBold.copyWith(
                color: AppColors.dangerDark,
              ),
            ),
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
