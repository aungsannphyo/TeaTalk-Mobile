import 'package:flutter/material.dart';

import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../domain/entities/user/user_tile_model.dart';
import '../../utils/date_time.dart';
import '../screens/friend/widget/avatar_widget.dart';
import '../../style/text_style.dart';
import '../../style/theme/app_color.dart';

class UserTileWidget extends StatelessWidget {
  final UserTileModel user;
  final String? imageUrl;
  final Function sendFriendRequest;
  final Function navigateToChat;
  final bool isLoading;

  const UserTileWidget({
    super.key,
    this.imageUrl,
    required this.sendFriendRequest,
    required this.user,
    required this.isLoading,
    required this.navigateToChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListTile(
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
              secondChild: AvatarWidget(
                username: user.username,
                profileImage: user.profileImage,
                baseUrl: imageUrl,
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
                  fontSize: 16,
                ),
              )
            : Text(
                "last seen at ${formatRelativeTime(user.lastSeen)}",
                style: AppTextStyles.regular.copyWith(
                  fontSize: 16,
                ),
              ),
        trailing: user.isFriend
            ? IconButton(
                onPressed: () {
                  navigateToChat(user);
                },
                icon: Icon(
                  Icons.messenger_outline,
                  color: AppColors.primary,
                ),
              )
            : IconButton(
                icon: Icon(
                  Icons.person_add_alt_outlined,
                  color: AppColors.primary,
                ),
                iconSize: 33,
                onPressed: isLoading ? null : () => sendFriendRequest(user.id),
              ),
      ),
    );
  }
}
