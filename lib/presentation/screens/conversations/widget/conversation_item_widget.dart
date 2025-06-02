import 'package:flutter/material.dart';

import '../../../../data/models/conversation/chat_list_response_model.dart';
import '../../../../style/text_style.dart';
import '../../../../utils/extensions.dart';
import "../../../../style/theme/app_color.dart";
import '../../../../utils/date_time.dart';
import '../../../widgets/common_avatar_widget.dart';

class ConversationItemWidget extends StatelessWidget {
  final ChatListResponseModel conversation;
  final bool isOnline;

  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Profile Image with village color avatar background
          Stack(
            children: [
              // Profile Avatar
              CommonAvatarWidget(
                username: conversation.name,
                profileImage: conversation.profileImage,
              ),

              if (!conversation.isGroup)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.onlineStatus : Colors.grey,
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
          const SizedBox(width: 12),
          // Name & Last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name.toTitleCase(),
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 18,
                    color: AppColors.textDark.withAlpha((0.8 * 255).round()),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (!conversation.isGroup)
                  Text(
                    conversation.lastMessageContent != null
                        ? conversation.lastMessageContent!
                        : 'You and ${conversation.name} are now connected',
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      color: AppColors.textDark.withAlpha((0.6 * 255).round()),
                    ),
                  ),
                if (conversation.isGroup)
                  Text(
                    conversation.lastMessageContent != null
                        ? conversation.lastMessageContent!
                        : 'You’ve joined the group — start chatting',
                    style: AppTextStyles.regular.copyWith(
                      fontSize: 15,
                      color: AppColors.textDark.withAlpha((0.6 * 255).round()),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                conversation.lastMessageCreatedAt != null
                    ? formatRelativeTime(conversation.lastMessageCreatedAt!)
                    : '',
                style: AppTextStyles.regular.copyWith(
                  fontSize: 15,
                  color: AppColors.textDark.withAlpha(
                    (0.6 * 255).round(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (conversation.unReadCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${conversation.unReadCount}',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
