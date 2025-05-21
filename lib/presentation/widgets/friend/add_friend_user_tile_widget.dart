import 'package:flutter/material.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../providers/user/search_user_provider.dart';
import '../common/common_elevate_button_widget.dart';
import 'avatar_widget.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';

class AddFriendUserTileWidget extends StatelessWidget {
  final SearchUserState searchState;
  final String? imageUrl;
  final Function sendFriendRequest;

  const AddFriendUserTileWidget({
    super.key,
    required this.searchState,
    this.imageUrl,
    required this.sendFriendRequest,
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
          secondChild: AvatarWidget(
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
        trailing: CommonElevateButtonWidget(
          onPressed: () {
            searchState.isLoading
                ? null
                : sendFriendRequest(searchState.user!.id);
          },
          label: searchState.isLoading ? 'Loading...' : 'Add Friend',
        ));
  }
}
