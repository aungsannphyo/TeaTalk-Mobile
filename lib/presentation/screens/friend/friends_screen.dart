import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/routes_name.dart';
import '../../../style/theme/app_color.dart';
import 'widget/friend/friend_action_item_widget.dart';

class FriendsScreen extends HookConsumerWidget {
  const FriendsScreen({super.key});

  // Dummy data for example
  final List<Map<String, dynamic>> friends = const [
    {
      'name': 'Alice Johnson',
      'lastSeen': '5 mins ago',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Bob Smith',
      'lastSeen': '2 hours ago',
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Charlie Brown',
      'lastSeen': 'Yesterday',
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToAddFriend() {
      GoRouter.of(context).pushNamed(RouteName.addFriend);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () =>
              GoRouter.of(context).pushNamed(RouteName.conversation),
        ),
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
              child: ListView.separated(
                itemCount: friends.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 10,
                  color: AppColors.bubbleShadow,
                ),
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(friend['avatarUrl']),
                    ),
                    title: Text(
                      friend['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      friend['lastSeen'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      // Navigate to chat or friend details
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
