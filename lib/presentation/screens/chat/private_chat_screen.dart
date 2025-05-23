import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/presentation/screens/chat/chat_appbar_widget.dart';

import '../../../style/theme/app_color.dart';
import 'chat_input_field_widget.dart';
import 'chat_messages_render_widget.dart';

class PrivateChatScreen extends HookConsumerWidget {
  final Map<String, dynamic>? friendInfo;
  const PrivateChatScreen({super.key, this.friendInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get friend info from constructor
    final extra = friendInfo;
    final friendId = extra?['id'] ?? '';
    // final profileImage = extra?['profileImage'] ?? '';
    final lastSeen = extra?['lastSeen'] ?? '';
    final isOnline = extra?['isOnline'] ?? false;
    final username = extra?['username'] ?? '';

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
        title: ChatAppbarWidget(
          username: username,
          isOnline: isOnline,
          lastSeen: lastSeen,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessagesRenderWidget(scrollController: scrollController),
          ),
          if (isLoadingMore.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            ),
          ChatInputFieldWidget(
            friendId: friendId,
            textController: textController,
            message: message,
            showEmojiPicker: showEmojiPicker,
            toggleEmojiPicker: toggleEmojiPicker,
            onEmojiSelected: onEmojiSelected,
          ),
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
}
