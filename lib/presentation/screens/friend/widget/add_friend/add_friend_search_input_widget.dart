import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../style/theme/app_color.dart';
import '../../../../providers/user/search_user_provider.dart';

class AddFriendSearchInputWidget extends HookConsumerWidget {
  final TextEditingController controller;
  const AddFriendSearchInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter Email or ID',
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.clear, color: AppColors.primary),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                    ref.read(searchUserProvider.notifier).reset();
                  },
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
