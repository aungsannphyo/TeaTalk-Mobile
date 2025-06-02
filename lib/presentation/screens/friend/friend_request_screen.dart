import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../../domain/events/decide_friend_request_event.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../../utils/date_time.dart';
import '../../providers/conversation/chat_list_provider.dart';
import '../../providers/friend/decide_friend_request_provider.dart';
import '../../providers/friend/friend_request_provider.dart';
import '../../widgets/custom_elevate_button_widget.dart';
import '../../widgets/custom_snack_bar_widget.dart';
import '../../widgets/placeholder_widget.dart';
import '../../widgets/common_avatar_widget.dart';

class FriendRequestScreen extends HookConsumerWidget {
  const FriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestState = ref.watch(friendRequestProvider);
    final requests = requestState.friendRequest ?? [];

    useEffect(() {
      Future.microtask(() {
        ref.read(friendRequestProvider.notifier).getAllFriendRequestLog();
      });
      return null;
    }, []);

    void handleFriendRequest(String friendRequestId, bool isReject) {
      final event = DecideFriendRequestEvent(
        status: isReject
            ? FriendRequestStatus.rejected.value
            : FriendRequestStatus.accepted.value,
        friendRequestId: friendRequestId,
      );
      ref.read(decideFriendRequestProvider.notifier).decideFriendRequest(event);
    }

    ref.listen<DecideFriendRequestState>(
      decideFriendRequestProvider,
      (previous, next) {
        if (next.isSuccess &&
            next.lastHandledRequestId != null &&
            next.lastAction != null) {
          final action = next.lastAction == FriendRequestStatus.accepted
              ? "accepted"
              : "rejected";
          ref
              .read(friendRequestProvider.notifier)
              .removeRequestById(next.lastHandledRequestId!);
          ref.read(chatListProvider.notifier).getChatList();
          SnackbarUtil.showSuccess(context, "Friend request $action!");

          Future.microtask(() {
            ref.read(decideFriendRequestProvider.notifier).reset();
          });
        } else if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        }
      },
    );

    if (requestState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Friend Requests', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: requests.isEmpty
          ? const PlaceholderWidget(
              imagePath: 'assets/images/no_data.svg',
              text:
                  'You have no pending friend requests.\nStart by connecting with people you know!',
              isSvg: true,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request = requests[index];
                final sentTime = formatRelativeTime(request.createAt);

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.bubbleShadow,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonAvatarWidget(
                        username: request.username,
                        profileImage: request.profileImage,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.username.toTitleCase(),
                                        style: AppTextStyles.semiBold
                                            .copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        request.email,
                                        style: AppTextStyles.regular.copyWith(
                                          fontSize: 14,
                                          color: AppColors.textDark
                                              .withAlpha((0.7 * 255).round()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  sentTime,
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 12.5,
                                    color: AppColors.textDark
                                        .withAlpha((0.5 * 255).round()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CustomElevateButtonWidget(
                                  label: "Confirm",
                                  onPressed: () => handleFriendRequest(
                                      request.requestId, false),
                                ),
                                const SizedBox(width: 8),
                                CustomElevateButtonWidget(
                                  label: "Delete Request",
                                  onPressed: () => handleFriendRequest(
                                      request.requestId, true),
                                  backgroundColor: AppColors.bubbleShadow,
                                  textColor: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
