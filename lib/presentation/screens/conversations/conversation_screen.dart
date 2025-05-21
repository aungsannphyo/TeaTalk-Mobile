import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/presentation/providers/friend/friend_request_provider.dart';
import 'package:tea_talk_mobile/style/text_style.dart';

import '../../../routes/routes_name.dart';
import '../../drawer/app_drawer.dart';
import '../../providers/auth/login_provider.dart';
import '../../providers/conversation/conversation_provider.dart';
import "../../../style/theme/app_color.dart";
import '../../widgets/conversation/conversation_item_widget.dart';
import '../../widgets/common/placeholder_widget.dart';

class ConversationScreen extends HookConsumerWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ConversationState conversationState = ref.watch(conversationProvider);
    final FriendRequestState friendRequestLogState =
        ref.watch(friendRequestProvider);

    final totalRequests = friendRequestLogState.friendRequest?.length ?? 0;

    useEffect(() {
      final userId = authState.auth?.id;
      if (userId != null) {
        Future.microtask(() {
          ref.read(conversationProvider.notifier).getConversations(userId);
          ref
              .read(friendRequestProvider.notifier)
              .getAllFriendRequestLog(userId);
        });
      }
      return null;
    }, [authState.auth]);

    void navigateToFriendRequestLog() {
      GoRouter.of(context).pushNamed(RouteName.friendRequestLog);
    }

    void navigateToAddFriend() {
      GoRouter.of(context).pushNamed(RouteName.addFriend);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(
        username: 'John Doe',
        email: 'john@example.com',
        profileImageUrl: null, // or provide a valid image URL
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigateToFriendRequestLog();
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications,
                  size: 28,
                ),
                if (totalRequests > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$totalRequests',
                        style: AppTextStyles.bold.copyWith(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: conversationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversationState.conversationList == null ||
                  conversationState.conversationList!.isEmpty
              ? PlaceholderWidget(
                  imagePath: 'assets/images/no-message.png',
                  text:
                      "You don’t have any conversations yet. Start chatting with your friends!",
                  isSvg: false,
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: conversationState.conversationList!.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 10,
                          color: AppColors.bubbleShadow,
                        ),
                        itemBuilder: (context, index) {
                          return ConversationItemWidget(
                              conversation:
                                  conversationState.conversationList![index]);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              navigateToAddFriend();
            },
            heroTag: 'addFriend',
            mini: true,
            backgroundColor: AppColors.complementary,
            tooltip: 'Add Friend',
            child: Icon(
              Icons.person_add_alt_1_outlined,
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                28,
              ),
            ),
            heroTag: 'startSendingAMessage',
            tooltip: 'Sent a message',
            child: Icon(
              Icons.chat_bubble_outline,
            ),
          ),
        ],
      ),
    );
  }
}
