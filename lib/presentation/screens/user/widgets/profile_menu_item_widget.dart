import 'package:flutter/material.dart';
import "../../../../style/theme/app_color.dart";

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? titleColor;
  final Function onClick;

  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.titleColor,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: iconColor ?? AppColors.textDark),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        onClick();
      },
    );
  }
}
