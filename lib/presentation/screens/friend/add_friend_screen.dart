import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/theme/app_color.dart';
import '../../providers/user/search_user_provider.dart';
import '../../providers/user/send_friend_request_provider.dart';
import '../../widgets/common/custom_snack_bar_widget.dart';
import '../../widgets/friend/add_friend_not_found_widget.dart';
import '../../widgets/friend/add_friend_search_input_widget.dart';
import '../../widgets/friend/add_friend_user_tile_widget.dart';

class AddFriendScreen extends HookConsumerWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = dotenv.env['API_URL'];

    final TextEditingController controller = useTextEditingController();
    final timer = useRef<Timer?>(null);
    final searchState = ref.watch(searchUserProvider);
    final searchUserNotifier = ref.read(searchUserProvider.notifier);
    final friendReqNotifier = ref.read(sendFriendReqProvider.notifier);

    void sendFriendRequest(String receiverID) {
      //make sure receiverID is not null or empty
      if (receiverID != "") {
        friendReqNotifier.sendFriendRequest(receiverID);
      }
    }

    useEffect(() {
      controller.addListener(() {
        final input = controller.text.trim();
        if (timer.value?.isActive ?? false) timer.value?.cancel();

        timer.value = Timer(const Duration(milliseconds: 400), () {
          if (input.isNotEmpty) {
            searchUserNotifier.searchUser(input);
          }
        });
      });

      return () => timer.value?.cancel();
    }, []);

    ref.listen<SendFriendRequestState>(
      sendFriendReqProvider,
      (previous, next) {
        if (next.errorCode == 409) {
          SnackbarUtil.showInfo(context, next.error!);
        } else if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        }
      },
    );

    ref.listen<SendFriendRequestState>(
      sendFriendReqProvider,
      (previous, next) {
        if (next.isSuccess) {
          SnackbarUtil.showSuccess(
            context,
            "Friend request sent!",
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddFriendSearchInputWidget(
              controller: controller,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  final input = controller.text.trim();

                  // Initial state - nothing typed yet
                  if (input.isEmpty) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 280),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/searching.svg',
                              height: 200,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  }

                  // If error or user not found
                  if (searchState.error != null || searchState.user == null) {
                    return AddFriendNotFoundWidget(
                      error: searchState.error ?? "User information not found.",
                    );
                  }

                  // User found
                  return AddFriendUserTileWidget(
                    imageUrl: imageUrl,
                    searchState: searchState,
                    sendFriendRequest: sendFriendRequest,
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
