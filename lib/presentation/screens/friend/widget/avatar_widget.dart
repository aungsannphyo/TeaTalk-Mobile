import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/avatar_background.dart';

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
      backgroundColor: hasValidImage ? Colors.grey[300] : Colors.white,
      backgroundImage: hasValidImage && baseUrl != null
          ? NetworkImage('$baseUrl$profileImage')
          : null,
      child: !hasValidImage
          ? SvgPicture.asset(
              getRandomDefaultAvatar(username),
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
            )
          : null,
    );
  }
}
