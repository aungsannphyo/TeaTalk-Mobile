import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../domain/websocket/listener/online_status_listener.dart';
import '../../../domain/websocket/online_status_map_provider.dart';
import '../../../routes/routes_name.dart';
import '../../../style/text_style.dart';
import '../../drawer/app_drawer.dart';
import '../../providers/conversation/chat_list_provider.dart';
import "../../../style/theme/app_color.dart";
import '../../providers/friend/friend_request_provider.dart';
import '../../providers/user/get_user_provider.dart';
import '../../widgets/loading/common_loading_widget.dart';
import 'widget/conversation_item_widget.dart';
import '../../widgets/placeholder_widget.dart';

class ConversationScreen extends HookConsumerWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(onlineStatusListenerProvider);
    final ChatListState conversationState = ref.watch(chatListProvider);
    final FriendRequestState friendRequestLogState =
        ref.watch(friendRequestProvider);
    final totalRequests = friendRequestLogState.friendRequest?.length ?? 0;

    useEffect(() {
      Future.microtask(() {
        ref.read(chatListProvider.notifier).getChatList();
        ref.read(friendRequestProvider.notifier).getAllFriendRequestLog();
        ref.read(getUserProvider.notifier).getUser();
      });
      return null;
    }, []);

    void navigateToFriendRequestLog() {
      GoRouter.of(context).pushNamed(RouteName.friendRequestLog);
    }

    void navigateToFriendScreen() {
      GoRouter.of(context).pushNamed(RouteName.friend);
    }

    void navigateToChat(ChatListResponseModel conversation) {
      //check private or group
      if (conversation.isGroup) {
        //for group
      } else {
        //for private
        GoRouter.of(context).pushNamed(
          RouteName.chat,
          extra: {
            'conversationId': conversation.conversationId,
            'friendId': conversation.receiverId,
            'profileImage': conversation.profileImage,
            'lastSeen': conversation.lastSeen,
            'username': conversation.name,
          },
        );
      }
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          drawer: const AppDrawer(),
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            title: Text(
              'Messages',
              style: AppTextStyles.appBarTitle,
            ),
            actions: totalRequests > 0
                ? [
                    IconButton(
                      onPressed: () {
                        navigateToFriendRequestLog();
                      },
                      icon: Badge(
                        label: Text(
                          totalRequests.toString(),
                        ),
                        child: Icon(
                          Icons.person_add,
                          size: 25,
                        ),
                      ),
                    ),
                  ]
                : null,
            centerTitle: true,
          ),
          body: conversationState.conversationList == null ||
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
                          final conversation =
                              conversationState.conversationList![index];
                          final onlineMap = ref.watch(onlineStatusMapProvider);
                          final isOnline = conversation.isGroup
                              ? (conversation.totalOnline > 0)
                              : (onlineMap[conversation.receiverId] ?? false);

                          return GestureDetector(
                            onTap: () {
                              navigateToChat(
                                conversationState.conversationList![index],
                              );
                            },
                            child: ConversationItemWidget(
                              conversation: conversation,
                              isOnline: isOnline,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateToFriendScreen();
            },
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
        ),
        if (conversationState.isLoading) CommonLoadingWidget(),
      ],
    );
  }
}
