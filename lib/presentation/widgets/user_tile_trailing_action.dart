import 'package:flutter/material.dart';

import '../../style/theme/app_color.dart';

class UserTileTrailingAction extends StatelessWidget {
  final bool isNavigateBtnShow;
  final bool isFriend;
  final VoidCallback onSendRequest;

  const UserTileTrailingAction({
    super.key,
    required this.isNavigateBtnShow,
    required this.isFriend,
    required this.onSendRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (!isNavigateBtnShow) return const SizedBox.shrink();

    if (!isFriend) {
      return IconButton(
        icon: Icon(Icons.person_add_alt_outlined, color: AppColors.primary),
        iconSize: 33,
        onPressed: onSendRequest,
      );
    }

    return const SizedBox.shrink();
  }
}
