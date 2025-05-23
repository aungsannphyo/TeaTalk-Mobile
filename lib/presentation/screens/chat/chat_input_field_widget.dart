import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';

class ChatInputFieldWidget extends StatelessWidget {
  final String friendId;
  final TextEditingController textController;
  final ValueNotifier<String> message;
  final ValueNotifier<bool> showEmojiPicker;
  final VoidCallback toggleEmojiPicker;
  final void Function(Emoji) onEmojiSelected;

  const ChatInputFieldWidget({
    super.key,
    required this.friendId,
    required this.textController,
    required this.message,
    required this.showEmojiPicker,
    required this.toggleEmojiPicker,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
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
                      // final content = textController.text.trim();
                      // if (content.isEmpty) return;

                      // final message = ChatMessage(
                      //   content: content,
                      //   targetId: friendId,
                      //   type: MessageType.private,
                      // );

                      // final wsController =
                      //     MessageType.private == MessageType.private
                      //         ? ref.read(privateWebSocketProvider)
                      //         : ref.read(groupWebSocketProvider);

                      // wsController?.send(message);
                      // textController.clear();
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
