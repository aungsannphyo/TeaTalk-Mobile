import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/models/message/message_model_response.dart';
import '../../../../domain/websocket/chat_message_model.dart';
import '../../../../domain/websocket/websocket_provider.dart';
import '../../../../style/text_style.dart';
import '../../../../style/theme/app_color.dart';
import '../../../providers/auth/login_provider.dart';

class ChatInputFieldWidget extends HookConsumerWidget {
  final String targetId;
  final MessageType messageType;
  final TextEditingController textController;
  final ValueNotifier<String> message;
  final ValueNotifier<bool> showEmojiPicker;
  final VoidCallback toggleEmojiPicker;
  final void Function(Emoji) onEmojiSelected;
  final void Function(MessageResponseModel) onMessageSent;

  const ChatInputFieldWidget({
    super.key,
    required this.textController,
    required this.message,
    required this.showEmojiPicker,
    required this.toggleEmojiPicker,
    required this.onEmojiSelected,
    required this.targetId,
    required this.messageType,
    required this.onMessageSent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void sendPrivateMessage(ValueNotifier<String> message) {
      if (message.value.isNotEmpty) {
        final content = textController.text.trim();
        if (content.isEmpty) return;

        final message = ChatMessageModel(
          senderId: ref.read(loginProvider).auth?.id ?? '',
          content: content,
          targetId: targetId,
          type: MessageType.private,
        );
        ref.read(privateWebSocketProvider)?.send(message);
        final messageModel = MessageResponseModel(
          messageId: Uuid().v4(),
          senderId: message.senderId,
          targetId: message.targetId,
          content: message.content,
          isRead: false,
          messageCreatedAt: DateTime.now(),
        );

        onMessageSent(messageModel);
        textController.clear();
      }
    }

    void sendGroupMessage(ValueNotifier<String> message) {}

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColors.background,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: AppTextStyles.regular,
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
                      MessageType.private == messageType
                          ? sendPrivateMessage(message)
                          : sendGroupMessage(message);
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
