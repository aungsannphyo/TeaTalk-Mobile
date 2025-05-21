import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/theme/app_color.dart';
import '../../providers/user/search_user_provider.dart';

class AddFriendScreen extends HookConsumerWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final List<Map<String, dynamic>> mockFriends = [
      {
        'name': 'Alice Johnson',
        'isOnline': true,
        'avatar': 'https://i.pravatar.cc/150?img=1',
      },
      {
        'name': 'Brian Lee',
        'isOnline': false,
        'avatar': 'https://i.pravatar.cc/150?img=2',
      },
      {
        'name': 'Carla Mendes',
        'isOnline': true,
        'avatar': 'https://i.pravatar.cc/150?img=3',
      },
    ];
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
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter User ID or Email',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: mockFriends.length,
                separatorBuilder: (_, __) =>
                    Divider(color: AppColors.bubbleShadow.withOpacity(0.3)),
                itemBuilder: (context, index) {
                  final friend = mockFriends[index];
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(friend['avatar']),
                          radius: 28,
                        ),
                        if (friend['isOnline'])
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.onlineStatus,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(friend['name'],
                        style: TextStyle(color: AppColors.textDark)),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Add', style: TextStyle(color: Colors.white)),
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
