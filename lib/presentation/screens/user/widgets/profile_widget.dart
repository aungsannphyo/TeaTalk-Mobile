import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/presentation/widgets/common_avatar_widget.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../../../routes/routes_name.dart';
import '../../../../style/text_style.dart';
import "../../../../style/theme/app_color.dart";
import '../../../providers/user/get_user_provider.dart';

class ProfileWidget extends HookConsumerWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userState = ref.watch(getUserProvider);

    void navigateToPersonalDetails() {
      GoRouter.of(context).pushNamed(RouteName.personalDetails);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            CommonAvatarWidget(
              radius: 50,
              username: userState.user != null
                  ? userState.user!.username.toTitleCase()
                  : "",
              profileImage: userState.details != null
                  ? userState.details!.profileImage
                  : "",
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: userState.details!.isOnline
                      ? AppColors.onlineStatus
                      : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userState.user != null
                    ? userState.user!.username.toTitleCase()
                    : "",
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userState.user != null ? userState.user!.email : "",
                style: AppTextStyles.regular.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    navigateToPersonalDetails();
                  },
                  icon: const Icon(
                    Icons.manage_accounts,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Edit Profile',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 14,
                      color: AppColors.background,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
