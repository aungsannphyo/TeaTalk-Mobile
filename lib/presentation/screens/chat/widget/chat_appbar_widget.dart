import 'package:flutter/material.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../../../style/text_style.dart';
import '../../../../style/theme/app_color.dart';
import '../../../../utils/date_time.dart';
import '../../../widgets/common_avatar_widget.dart';

class ChatAppbarWidget extends StatelessWidget {
  final String username;
  final bool isOnline;
  final String lastSeen;

  const ChatAppbarWidget({
    super.key,
    required this.username,
    required this.isOnline,
    required this.lastSeen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonAvatarWidget(
          username: username,
          radius: 24,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username.isNotEmpty
                  ? username.toString().toTitleCase()
                  : 'Unknown',
              style: AppTextStyles.bold
                  .copyWith(color: Colors.white, fontSize: 18),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOnline ? AppColors.onlineStatus : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline
                      ? 'Online'
                      : (lastSeen.isNotEmpty
                          ? formatRelativeTime(lastSeen)
                          : 'Offline'),
                  style: AppTextStyles.regular.copyWith(
                    color: Colors.white.withAlpha((0.8 * 255).toInt()),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
