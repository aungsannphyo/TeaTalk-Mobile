import 'package:flutter/material.dart';

import '../../../../style/text_style.dart';
import '../../../../style/theme/app_color.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  const MessageBubbleWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.complementary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bubbleShadow..withAlpha((0.2 * 255).toInt()),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: isMe
                  ? AppTextStyles.semiBold
                      .copyWith(color: Colors.white, fontSize: 17)
                  : AppTextStyles.semiBold.copyWith(
                      color: Color.alphaBlend(
                        AppColors.textDark.withAlpha((0.85 * 255).toInt()),
                        Colors.transparent,
                      ),
                      fontSize: 17),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: isMe
                      ? AppTextStyles.timestamp.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        )
                      : AppTextStyles.timestamp.copyWith(
                          color: AppColors.textDark.withAlpha(
                            (0.6 * 255).toInt(),
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                ),
                if (isMe)
                  Row(
                    children: [
                      Icon(
                        isRead ? Icons.remove_red_eye : Icons.check,
                        size: 18,
                        color: Colors.white, // Always white for both icons
                      ),
                      if (isRead)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Seen',
                            style: AppTextStyles.semiBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
