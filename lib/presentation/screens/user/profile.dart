import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/text_style.dart';
import '../../providers/user/get_user_provider.dart';
import 'widgets/profile_menu_item_widget.dart';
import 'widgets/profile_widget.dart';
import '../../../routes/routes_name.dart';
import '../../../style/theme/app_color.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userState = ref.watch(getUserProvider);

    void navigateToPersonalDetails() {
      GoRouter.of(context).pushNamed(RouteName.personalDetails);
    }

    void navigateToQrScreen() {
      GoRouter.of(context).pushNamed(RouteName.userQr);
    }

    final details = userState.details;
    final isComplete = details != null &&
        details.bio != null &&
        details.dateOfBirth != null &&
        details.gender != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigateToQrScreen();
            },
            icon: Icon(
              Icons.qr_code_outlined,
            ),
          ),
        ],
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
            Text(
              "Account Settings",
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ProfileMenuItemWidget(
              icon: Icons.fact_check,
              title: "Complete Personal Details",
              iconColor: isComplete ? AppColors.success : AppColors.warning,
              titleColor:
                  isComplete ? AppColors.successDark : AppColors.warningDark,
              onClick: () {
                navigateToPersonalDetails();
              },
            ),

            ProfileMenuItemWidget(
              icon: Icons.lock_outline,
              title: "Change Password",
              onClick: () {},
            ),
            Divider(height: 30, color: AppColors.bubbleShadow),

            // Section: Preferences
            Text(
              "Preferences",
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ProfileMenuItemWidget(
              icon: Icons.brightness_6,
              title: "Theme",
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
