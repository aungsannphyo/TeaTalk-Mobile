import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';

import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../../utils/date_time.dart';
import '../../providers/auth/login_provider.dart';
import '../../providers/friend/friend_request_log_provider.dart';
import '../../widgets/common/common_elevate_button_widget.dart';
import '../../widgets/friend/avatar_widget.dart';

class FriendRequestLogScreen extends HookConsumerWidget {
  const FriendRequestLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = dotenv.env['API_URL'];
    final authState = ref.watch(authProvider);
    final requestState = ref.watch(friendRequestLogProvider);
    final notifier = ref.read(friendRequestLogProvider.notifier);

    useEffect(() {
      final userId = authState.auth?.id;
      if (userId != null) {
        Future.microtask(() {
          notifier.getAllFriendRequestLog(userId);
        });
      }
      return null;
    }, [authState.auth]);

    final requests = requestState.friendRequestLogs ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Friend Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
      ),
      body: requestState.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : requests.isEmpty
              ? const Center(child: Text("No pending friend requests."))
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
                          AvatarWidget(
                            username: request.username,
                            profileImage: request.profileImage,
                            baseUrl: imageUrl,
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
                                            style:
                                                AppTextStyles.regular.copyWith(
                                              fontSize: 14,
                                              color: AppColors.textDark
                                                  .withAlpha(
                                                      (0.7 * 255).round()),
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
                                    CommonElevateButtonWidget(
                                      label: "Confirm",
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 8),
                                    CommonElevateButtonWidget(
                                      label: "Delete Request",
                                      onPressed: () {},
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
