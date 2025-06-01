import 'package:flutter/material.dart';

import '../../../../../style/text_style.dart';
import '../../../../../style/theme/app_color.dart';

class FriendActionItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FriendActionItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.semiBold.copyWith(
                color: AppColors.primary,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
