import 'package:flutter/material.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../providers/user/search_user_provider.dart';
import './add_friend_avatar_widget.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';

class AddFriendUserTileWidget extends StatelessWidget {
  final SearchUserState searchState;
  final String? imageUrl;

  const AddFriendUserTileWidget({
    super.key,
    required this.searchState,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        secondChild: AddFriendAvatarWidget(
          username: searchState.user?.username ?? '',
          profileImage: searchState.user?.profileImage,
          baseUrl: imageUrl,
        ),
        crossFadeState: searchState.isLoading
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
      title: Text(
        (searchState.user?.username.isNotEmpty ?? false)
            ? searchState.user!.username.toTitleCase()
            : '',
        style: TextStyle(color: AppColors.textDark),
      ),
      trailing: ElevatedButton.icon(
        onPressed: searchState.isLoading ? null : () {},
        icon: searchState.isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(Icons.person_add, color: Colors.white),
        label: Text(
          searchState.isLoading ? 'Loading...' : 'Add Friend',
          style: AppTextStyles.semiBold.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
