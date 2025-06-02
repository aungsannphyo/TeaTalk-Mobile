import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/friend/friend_response_model.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/friend/friend_provider.dart';
import '../../widgets/placeholder_widget.dart';
import '../../widgets/user_tile_widget.dart';
import '../../widgets/common_avatar_widget.dart';

class NewGroupScreen extends HookConsumerWidget {
  const NewGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendState = ref.watch(friendProvider);
    final searchController = useTextEditingController();
    final memberList = useState<List<FriendResponseModel>>([]);
    final searchQuery = useState('');

    useEffect(() {
      Future.microtask(() {
        ref.read(friendProvider.notifier).getFriends();
      });
      return null;
    }, []);

    // Helpers
    void toggleMember(FriendResponseModel friend) {
      final exists = memberList.value.any((m) => m.id == friend.id);
      memberList.value = exists
          ? memberList.value.where((m) => m.id != friend.id).toList()
          : [...memberList.value, friend];
    }

    final displayedFriends = (searchQuery.value.trim().isEmpty)
        ? (friendState.friends ?? [])
        : (friendState.friends ?? []).where((friend) {
            return friend.username
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
          }).toList();

    Widget buildSearchField() {
      return TextField(
        controller: searchController,
        onChanged: (value) => searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Who would you like to add?',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    Widget buildSelectedChips() {
      if (memberList.value.isEmpty) return const SizedBox();
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: memberList.value
            .map((member) => Chip(
                  avatar: SizedBox(
                    child: CommonAvatarWidget(
                      username: member.username,
                      radius: 15,
                      profileImage: member.profileImage,
                    ),
                  ),
                  label: Text(member.username),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => toggleMember(member),
                ))
            .toList(),
      );
    }

    Widget buildFriendList() {
      if (friendState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if ((friendState.friends ?? []).isEmpty) {
        return const PlaceholderWidget(
          imagePath: 'assets/images/add_friend.svg',
          text: "It's quiet here... add a friend to start a conversation.",
          isSvg: true,
        );
      }

      final friends = displayedFriends;
      if (searchQuery.value.trim().isNotEmpty && friends.isEmpty) {
        return const PlaceholderWidget(
          imagePath: 'assets/images/no_data.svg',
          text: "No friends match your search.",
          isSvg: true,
        );
      }

      return ListView.separated(
        itemCount: friends.length,
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.bubbleShadow),
        itemBuilder: (context, index) {
          final friend = friends[index];
          final isSelected = memberList.value.any((m) => m.id == friend.id);

          return Material(
            color: AppColors.background,
            child: InkWell(
              onTap: () => toggleMember(friend),
              child: UserTileWidget(
                sendFriendRequest: () {},
                user: friend,
                isLoading: friendState.isLoading,
                isNavigateBtnShow: false,
                isSelected: isSelected,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('New Group', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchField(),
            const SizedBox(height: 10),
            buildSelectedChips(),
            const SizedBox(height: 10),
            Expanded(child: buildFriendList()),
          ],
        ),
      ),
    );
  }
}
