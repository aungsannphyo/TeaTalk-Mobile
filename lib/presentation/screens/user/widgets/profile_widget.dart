import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../../../style/text_style.dart';
import "../../../../style/theme/app_color.dart";
import '../../../providers/user/get_user_provider.dart';
import 'profile_avatar_widget.dart';

class ProfileWidget extends HookConsumerWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userAsync = ref.watch(getUserProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatarWidget(
          username: userAsync.user != null
              ? userAsync.user!.username.toTitleCase()
              : "",
          profileImageUrl:
              userAsync.details != null ? userAsync.details!.profileImage : "",
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userAsync.user != null
                    ? userAsync.user!.username.toTitleCase()
                    : "",
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userAsync.user != null ? userAsync.user!.email : "",
                style: AppTextStyles.regular.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
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
