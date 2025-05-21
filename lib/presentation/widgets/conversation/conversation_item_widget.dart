import 'package:flutter/material.dart';
import '../../../utils/avatar_background.dart';
import '../../../utils/extensions.dart';
import '../../../domain/entities/conversation/conversation_model.dart';
import "../../../style/theme/app_color.dart";
import '../../../utils/date_time.dart';

class ConversationItemWidget extends StatelessWidget {
  final ConversationModel conversation;
  const ConversationItemWidget({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Profile Image with village color avatar background
          CircleAvatar(
            radius: 28,
            backgroundColor: avatarBackground(conversation.name),
            child: Text(
              conversation.name.isNotEmpty
                  ? conversation.name[0].toUpperCase()
                  : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name & Last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.name.toTitleCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  conversation.lastMessageContent,
                  style: TextStyle(
                    fontSize: 14,
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
                formatRelativeTime(conversation.lastMessageCreatedAt),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark.withAlpha((0.5 * 255).round()),
                  fontWeight: FontWeight.w400,
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
