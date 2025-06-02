import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';
import '../providers/user/get_user_provider.dart';
import '../screens/friend/widget/avatar_widget.dart';

class AppDrawerHeader extends HookConsumerWidget {
  const AppDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userState = ref.watch(getUserProvider);

    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(
            username: userState.user!.username.toTitleCase(),
            profileImage: userState.details!.profileImage,
            radius: 35,
          ),
          const SizedBox(height: 10),
          Text(
            userState.user!.username.toTitleCase(),
            style: AppTextStyles.bold.copyWith(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          Text(
            userState.user!.email,
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
