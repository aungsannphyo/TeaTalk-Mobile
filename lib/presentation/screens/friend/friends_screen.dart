import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/presentation/widgets/user_tile_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/friend/friend_provider.dart';
import '../../widgets/placeholder_widget.dart';
import 'widget/friend/friend_action_item_widget.dart';

class FriendsScreen extends HookConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendState = ref.watch(friendProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(friendProvider.notifier).getFriends();
      });

      return null;
    }, []);

    void navigateToAddFriend() {
      GoRouter.of(context).pushNamed(RouteName.addFriend);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FriendActionItemWidget(
                  icon: Icons.group_outlined,
                  label: 'New Group',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                FriendActionItemWidget(
                  icon: Icons.person_add_outlined,
                  label: 'New Friend',
                  onTap: () {
                    navigateToAddFriend();
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(
              height: 10,
              color: AppColors.bubbleShadow,
            ),
            // Friends list
            Expanded(
              child: friendState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : friendState.friends == null || friendState.friends!.isEmpty
                      ? PlaceholderWidget(
                          imagePath: 'assets/images/no-message.png',
                          text:
                              "You don’t have any conversations yet. Start chatting with your friends!",
                          isSvg: false,
                        )
                      : ListView.separated(
                          itemCount: friendState.friends!.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 10,
                            color: AppColors.bubbleShadow,
                          ),
                          itemBuilder: (context, index) {
                            final friend = friendState.friends![index];
                            return UserTileWidget(
                              sendFriendRequest: () {},
                              user: friend,
                              isLoading: friendState.isLoading,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
