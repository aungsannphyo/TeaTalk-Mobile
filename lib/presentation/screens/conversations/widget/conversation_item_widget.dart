import 'package:flutter/material.dart';

import '../../../../data/models/conversation/conversation_model_response.dart';
import '../../../../style/text_style.dart';
import '../../../../utils/extensions.dart';
import "../../../../style/theme/app_color.dart";
import '../../../../utils/date_time.dart';
import '../../friend/widget/avatar_widget.dart';

class ConversationItemWidget extends StatelessWidget {
  final ConversationResponseModel conversation;
  const ConversationItemWidget({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Profile Image with village color avatar background
          AvatarWidget(
            username: conversation.name,
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
                Text(
                  conversation.lastMessageContent != null
                      ? conversation.lastMessageContent!
                      : '',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 15,
                    color: AppColors.textDark.withAlpha((0.6 * 255).round()),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
