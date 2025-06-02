import 'package:flutter/material.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../domain/entities/user/user_tile_model.dart';
import '../../utils/date_time.dart';
import 'common_avatar_widget.dart';
import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';
import 'user_tile_trailing_action.dart';

class UserTileWidget extends StatelessWidget {
  final UserTileModel user;
  final Function sendFriendRequest;
  final bool isLoading;
  final bool isNavigateBtnShow;
  final bool isSelected;

  const UserTileWidget({
    super.key,
    required this.sendFriendRequest,
    required this.user,
    required this.isLoading,
    required this.isNavigateBtnShow,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            secondChild: CommonAvatarWidget(
              username: user.username,
              profileImage: user.profileImage,
            ),
            crossFadeState: isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          if (user.isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.onlineStatus,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          if (isSelected)
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
        ],
      ),
      title: Text(
        user.username.toTitleCase(),
        style: AppTextStyles.semiBold.copyWith(fontSize: 16),
      ),
      subtitle: user.isOnline
          ? Text(
              "online",
              style: AppTextStyles.regular.copyWith(
                fontSize: 13,
              ),
            )
          : Text(
              formatRelativeTime(user.lastSeen),
              style: AppTextStyles.regular.copyWith(
                fontSize: 13,
              ),
            ),
      trailing: UserTileTrailingAction(
        isNavigateBtnShow: isNavigateBtnShow,
        isFriend: user.isFriend,
        onSendRequest: () => sendFriendRequest(user.id),
      ),
    );
  }
}
