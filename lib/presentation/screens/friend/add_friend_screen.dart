import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/theme/app_color.dart';
import '../../providers/user/search_user_provider.dart';
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
    final notifier = ref.read(searchUserProvider.notifier);

    useEffect(() {
      controller.addListener(() {
        final input = controller.text.trim();
        if (timer.value?.isActive ?? false) timer.value?.cancel();

        timer.value = Timer(const Duration(milliseconds: 400), () {
          if (input.isNotEmpty) {
            notifier.searchUser(input);
          }
        });
      });

      return () => timer.value?.cancel();
    }, []);

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
              child: searchState.error != null
                  ? AddFriendNotFoundWidget(
                      error: searchState.error.toString(),
                    )
                  : AddFriendUserTileWidget(
                      imageUrl: imageUrl,
                      searchState: searchState,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
