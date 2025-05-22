import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/utils/date_time.dart';
import 'package:tea_talk_mobile/utils/extensions.dart';
import '../../../style/theme/app_color.dart';
import '../../../style/text_style.dart';
import '../friend/widget/avatar_widget.dart';

class ChatScreen extends HookConsumerWidget {
  final Map<String, dynamic>? friendInfo;
  const ChatScreen({super.key, this.friendInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get friend info from constructor
    final extra = friendInfo;
    final friendId = extra?['id'] ?? '';
    final profileImage = extra?['profileImage'] ?? '';
    final lastSeen = extra?['lastSeen'] ?? '';
    final isOnline = extra?['isOnline'] ?? false;
    final username = extra?['username'] ?? '';

    print("EXTRA $extra");

    final textController = useTextEditingController();
    final showEmojiPicker = useState(false);
    final message = useState('');
    final scrollController = useScrollController();
    final isLoadingMore = useState(false);

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels <=
                scrollController.position.minScrollExtent + 50 &&
            !isLoadingMore.value) {
          isLoadingMore.value = true;
          // TODO: Load more messages here (e.g., call a provider or fetch from API)
          Future.delayed(const Duration(seconds: 1), () {
            isLoadingMore.value = false;
          });
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    void onEmojiSelected(Emoji emoji) {
      textController.text += emoji.emoji;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
      message.value = textController.text;
    }

    void toggleEmojiPicker() {
      showEmojiPicker.value = !showEmojiPicker.value;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            AvatarWidget(username: username),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username.isNotEmpty
                      ? username.toString().toTitleCase()
                      : 'Unknown',
                  style: AppTextStyles.bold
                      .copyWith(color: Colors.white, fontSize: 20),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.onlineStatus : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOnline
                          ? 'Online'
                          : (lastSeen.isNotEmpty
                              ? 'Last seen ${formatRelativeTime(lastSeen)}'
                              : 'Offline'),
                      style: AppTextStyles.regular.copyWith(
                        color: Colors.white.withAlpha((0.8 * 255).toInt()),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              reverse: true,
              children: [
                _buildMessageBubble(
                  context,
                  text: 'Hello! How are you?',
                  isMe: false,
                  time: '09:00',
                ),
                _buildMessageBubble(
                  context,
                  text: 'I am good, thanks! And you?',
                  isMe: true,
                  time: '09:01',
                  isRead: true,
                ),
                _buildMessageBubble(
                  context,
                  text: 'Doing well! Ready for our meeting?',
                  isMe: false,
                  time: '09:02',
                ),
                // ... more sample messages ...
              ],
            ),
          ),
          if (isLoadingMore.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            ),
          _buildInputBar(context, textController, message, showEmojiPicker,
              toggleEmojiPicker, onEmojiSelected),
          if (showEmojiPicker.value)
            SizedBox(
              height: 300,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) => onEmojiSelected(emoji),
                config: Config(
                  columns: 7,
                  emojiSizeMax: 28,
                  bgColor: AppColors.background,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context,
      {required String text,
      required bool isMe,
      required String time,
      bool isRead = false}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.complementary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bubbleShadow..withAlpha((0.2 * 255).toInt()),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: isMe
                  ? AppTextStyles.semiBold
                      .copyWith(color: Colors.white, fontSize: 17)
                  : AppTextStyles.semiBold.copyWith(
                      color: Color.alphaBlend(
                        AppColors.textDark.withAlpha((0.85 * 255).toInt()),
                        Colors.transparent,
                      ),
                      fontSize: 17),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: isMe
                      ? AppTextStyles.semiBold
                          .copyWith(color: Colors.white70, fontSize: 14)
                      : AppTextStyles.semiBold.copyWith(
                          color: Color.alphaBlend(
                            AppColors.textDark.withAlpha((0.6 * 255).toInt()),
                            Colors.transparent,
                          ),
                          fontSize: 14),
                ),
                if (isMe)
                  Row(
                    children: [
                      Icon(
                        isRead ? Icons.remove_red_eye : Icons.check,
                        size: 18,
                        color: Colors.white, // Always white for both icons
                      ),
                      if (isRead)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Seen',
                            style: AppTextStyles.semiBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    TextEditingController textController,
    ValueNotifier<String> message,
    ValueNotifier<bool> showEmojiPicker,
    VoidCallback toggleEmojiPicker,
    void Function(Emoji) onEmojiSelected,
  ) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.complementary..withAlpha((0.5 * 255).toInt()),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColors.background,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: AppTextStyles.semiBold,
                    onChanged: (val) => message.value = val,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: AppTextStyles.semiBold.copyWith(
                          color: AppColors.textDark
                              .withAlpha((0.5 * 255).toInt())),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onPressed: toggleEmojiPicker,
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    minLines: 1,
                    maxLines: 5,
                    onTap: () {
                      if (showEmojiPicker.value) {
                        showEmojiPicker.value = false;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // You can use message.value here for sending
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
