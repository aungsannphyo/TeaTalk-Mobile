import 'package:flutter/material.dart';

import '../../../style/theme/app_color.dart';

class AddFriendSearchInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const AddFriendSearchInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter Name, Email or ID',
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.clear, color: AppColors.primary),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
