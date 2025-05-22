import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/friend/friend_model.dart';
import '../../../routes/routes_name.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/user/search_user_provider.dart';
import '../../providers/user/send_friend_request_provider.dart';
import '../../widgets/custom_snack_bar_widget.dart';
import '../../widgets/placeholder_widget.dart';
import 'widget/add_friend/add_friend_search_input_widget.dart';
import '../../widgets/user_tile_widget.dart';

class AddFriendScreen extends HookConsumerWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = dotenv.env['API_URL'];

    final TextEditingController controller = useTextEditingController();
    final timer = useRef<Timer?>(null);

    final searchState = ref.watch(searchUserProvider);
    final searchUserNotifier = ref.read(searchUserProvider.notifier);

    final friendReqState = ref.watch(sendFriendReqProvider);
    final friendReqNotifier = ref.read(sendFriendReqProvider.notifier);

    void sendFriendRequest(String receiverID) {
      if (receiverID.isNotEmpty && !friendReqState.isLoading) {
        friendReqNotifier.sendFriendRequest(receiverID);
      }
    }

    // Debounce search input
    useEffect(() {
      void listener() {
        final input = controller.text.trim();
        if (timer.value?.isActive ?? false) timer.value?.cancel();

        timer.value = Timer(const Duration(milliseconds: 400), () {
          if (input.isNotEmpty) {
            searchUserNotifier.searchUser(input);
          } else {
            ref.read(searchUserProvider.notifier).reset();
          }
        });
      }

      controller.addListener(listener);

      return () {
        timer.value?.cancel();
        controller.removeListener(listener);
      };
    }, [controller]);

    void navigateToChat(FriendModel friend) {
      GoRouter.of(context).pushNamed(
        RouteName.chat,
        extra: {
          'id': friend.id,
          'profileImage': friend.profileImage,
          'lastSeen': friend.lastSeen.toString(),
          'isOnline': friend.isOnline,
          'username': friend.username,
        },
      );
    }

    // Listen for friend request errors and success
    ref.listen<SendFriendRequestState>(
      sendFriendReqProvider,
      (previous, next) {
        if (next.errorCode == 409) {
          SnackbarUtil.showInfo(context, next.error ?? next.error.toString());
        } else if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        } else if (next.isSuccess) {
          SnackbarUtil.showSuccess(context, 'Friend request sent!');
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Add Friend',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddFriendSearchInputWidget(controller: controller),
            const SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  final input = controller.text.trim();

                  if (input.isEmpty) {
                    return PlaceholderWidget(
                      imagePath: 'assets/images/searching.svg',
                      text: 'Start typing to search for friends',
                      isSvg: true,
                    );
                  }
                  if (searchState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (searchState.users.isEmpty) {
                    return PlaceholderWidget(
                      imagePath: 'assets/images/404.svg',
                      text:
                          "Looks like nobody’s here yet. Try searching again!",
                      isSvg: true,
                    );
                  }

                  return ListView.separated(
                    itemCount: searchState.users.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 10,
                      color: AppColors.bubbleShadow,
                    ),
                    itemBuilder: (context, index) {
                      final user = searchState.users[index];
                      return UserTileWidget(
                        imageUrl: imageUrl,
                        user: user,
                        navigateToChat: navigateToChat,
                        sendFriendRequest: sendFriendRequest,
                        isLoading: friendReqState.isLoading,
                      );
                    },
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
