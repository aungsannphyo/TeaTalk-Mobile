import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/theme/app_color.dart';
import '../../friend/widget/avatar_widget.dart';

class ProfileAvatarWidget extends HookConsumerWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(60),
          ),
          child: const AvatarWidget(
            username: "Charlotte King",
            radius: 50,
          ),
        ),
      ],
    );
  }
}
