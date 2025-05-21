import 'package:flutter/material.dart';

import '../../../style/theme/app_color.dart';

class ConversationPopUpMenuWidget extends StatelessWidget {
  final Function onMenuSelected;
  const ConversationPopUpMenuWidget({
    super.key,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.group_add_outlined, color: Colors.white),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) => onMenuSelected(context, value),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'add_friend',
          child: Row(
            children: [
              Icon(Icons.person_add_alt_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Text("Add Friend"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'friends_list',
          child: Row(
            children: [
              Icon(Icons.people_outline, color: AppColors.complementary),
              SizedBox(width: 10),
              Text("Friends"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'create_group',
          child: Row(
            children: [
              Icon(Icons.group_outlined, color: AppColors.accent),
              SizedBox(width: 10),
              Text("Create Group"),
            ],
          ),
        ),
      ],
    );
  }
}
