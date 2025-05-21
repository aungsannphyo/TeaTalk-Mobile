import 'package:flutter/material.dart';

import '../../../utils/avatar_background.dart';

class AvatarWidget extends StatelessWidget {
  final String? profileImage;
  final String username;
  final String? baseUrl;
  final double radius;

  const AvatarWidget({
    super.key,
    required this.username,
    this.profileImage,
    this.baseUrl,
    this.radius = 28,
  });

  bool get hasValidImage =>
      profileImage != null &&
      profileImage!.isNotEmpty &&
      profileImage!.toLowerCase() != 'null';

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          hasValidImage ? Colors.grey[300] : avatarBackground(username),
      backgroundImage: hasValidImage && baseUrl != null
          ? NetworkImage('$baseUrl$profileImage')
          : null,
      child: !hasValidImage
          ? Text(
              username.isNotEmpty ? username[0].toUpperCase() : '',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            )
          : null,
    );
  }
}
