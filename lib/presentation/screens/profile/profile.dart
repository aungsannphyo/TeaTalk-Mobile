import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ywar_talk_mobile/presentation/providers/auth/auth_provider.dart';
import 'package:ywar_talk_mobile/presentation/widgets/profile/profile_menu_item_widget.dart';
import 'package:ywar_talk_mobile/presentation/widgets/profile/profile_widget.dart';
import '../../../style/theme/color.dart'; // AppColors

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logout() {
      ref.read(authProvider.notifier).logout();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ProfileWidget(),
            ),
            const SizedBox(height: 20),

            // Section: Personal Info
            const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ProfileMenuItemWidget(
              icon: Icons.fact_check,
              title: "Complete Personal Details",
              iconColor: AppColors.success,
              titleColor: AppColors.successDark,
              onClick: () {},
            ),

            ProfileMenuItemWidget(
              icon: Icons.lock_outline,
              title: "Change Password",
              onClick: () {},
            ),
            Divider(height: 30, color: AppColors.bubbleShadow),

            // Section: Preferences
            const Text(
              "Preferences",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ProfileMenuItemWidget(
              icon: Icons.brightness_6,
              title: "Theme",
              onClick: () {},
            ),
            Divider(height: 30, color: AppColors.bubbleShadow),

            // Logout
            ProfileMenuItemWidget(
              icon: Icons.logout,
              title: "Log Out",
              iconColor: AppColors.danger,
              titleColor: AppColors.dangerDark,
              onClick: logout,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
