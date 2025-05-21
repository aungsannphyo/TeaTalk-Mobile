import 'package:flutter/material.dart';

import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';

class AddFriendNotFoundWidget extends StatelessWidget {
  final String error;
  const AddFriendNotFoundWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: AppColors.accent,
          ),
          SizedBox(height: 12),
          Text(
            error.toString(),
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 17,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
