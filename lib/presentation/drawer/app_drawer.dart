import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routes/routes_name.dart';
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

    void navigateToContact() {
      GoRouter.of(context).pushNamed(RouteName.friend);
    }

    void navigateToMyProfile() {
      GoRouter.of(context).pushNamed(RouteName.profile);
    }

    void navigateToNewGroup() {
      GoRouter.of(context).pushNamed(RouteName.newGroup);
    }

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
              navigateToMyProfile();
            },
          ),
          const Divider(color: AppColors.bubbleShadow),
          ListTile(
            leading: const Icon(
              Icons.group_outlined,
              color: AppColors.textDark,
            ),
            title: Text(
              'New Group',
              style: AppTextStyles.semiBold,
            ),
            onTap: () {
              navigateToNewGroup();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_box_outlined,
              color: AppColors.textDark,
            ),
            title: Text(
              'Friends',
              style: AppTextStyles.semiBold,
            ),
            onTap: () {
              navigateToContact();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: AppColors.textDark,
            ),
            title: Text(
              'Settings',
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
              ref.read(loginProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
