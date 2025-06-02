import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/friend/friend_response_model.dart';
import '../../../domain/events/get_conversation_event.dart';
import '../../../routes/routes_name.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/auth/login_provider.dart';
import '../../providers/conversation/conversation_provider.dart';
import '../../providers/friend/friend_provider.dart';
import '../../widgets/placeholder_widget.dart';
import '../../widgets/user_tile_widget.dart';
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

    void navigateToNewGroup() {
      GoRouter.of(context).pushNamed(RouteName.newGroup);
    }

    void navigateToChat(FriendResponseModel friend) {
      final AuthState authState = ref.read(loginProvider);
      final senderId = authState.auth?.id;

      if (senderId == null) {
        return;
      }
      final getEvent =
          GetConversationEvent(senderId: senderId, receiverId: friend.id);
      ref.read(conversationProvider.notifier).getConversation(getEvent);

      // Declare subscription first
      late ProviderSubscription<ConversationState> subscription;

      subscription = ref.listenManual<ConversationState>(
        conversationProvider,
        (previous, next) {
          if (next.conversation != null && !next.isLoading) {
            GoRouter.of(context).pushNamed(
              RouteName.chat,
              extra: {
                'conversationId': next.conversation?.conversationId,
                'friendId': friend.id,
                'profileImage': friend.profileImage,
                'lastSeen': friend.lastSeen,
                'username': friend.username,
              },
            );
            subscription.close();
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Friends',
          style: AppTextStyles.appBarTitle,
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
                  onTap: () {
                    navigateToNewGroup();
                  },
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
                          imagePath: 'assets/images/add_friend.svg',
                          text:
                              "It's quiet here... add a friend to start a conversation.",
                          isSvg: true,
                        )
                      : ListView.separated(
                          itemCount: friendState.friends!.length,
                          separatorBuilder: (_, __) => const Divider(
                            color: AppColors.bubbleShadow,
                          ),
                          itemBuilder: (context, index) {
                            final friend = friendState.friends![index];
                            return InkWell(
                              onTap: () => navigateToChat(friend),
                              child: UserTileWidget(
                                sendFriendRequest: () {},
                                user: friend,
                                isLoading: friendState.isLoading,
                                isNavigateBtnShow: true,
                              ),
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
