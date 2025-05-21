import 'package:flutter/material.dart';

import '../../../style/theme/color.dart';

class NoConversationWidget extends StatelessWidget {
  const NoConversationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/no-message.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              color: AppColors.accent,
            ),
            SizedBox(height: 16),
            Text(
              "You don’t have any conversations yet. Start chatting with your friends!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
