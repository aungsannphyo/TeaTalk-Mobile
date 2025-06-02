import 'package:flutter/material.dart';

import '../../../../style/theme/app_color.dart';
import '../../friend/widget/avatar_widget.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String username;
  final String? profileImageUrl;

  const ProfileAvatarWidget({
    super.key,
    required this.username,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(60),
          ),
          child: AvatarWidget(
            username: username,
            profileImage: profileImageUrl,
            radius: 50,
          ),
        ),
      ],
    );
  }
}
