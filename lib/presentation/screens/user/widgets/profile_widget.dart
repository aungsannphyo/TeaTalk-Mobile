import 'package:flutter/material.dart';

import "../../../../style/theme/app_color.dart";
import 'profile_avatar_widget.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileAvatarWidget(),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Charlotte King',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'batman@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.manage_accounts,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
