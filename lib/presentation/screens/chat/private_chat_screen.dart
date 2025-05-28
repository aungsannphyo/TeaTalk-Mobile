import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/message/message_model_response.dart';
import '../../../domain/websocket/chat_message_model.dart';
import '../../../domain/websocket/online_status_map_provider.dart';
import '../../../domain/websocket/websocket_provider.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/message/message_provider.dart';
import 'widget/chat_appbar_widget.dart';
import 'widget/chat_input_field_widget.dart';
import 'widget/chat_messages_render_widget.dart';

class PrivateChatScreen extends HookConsumerWidget {
  final Map<String, dynamic>? chatInfo;
  const PrivateChatScreen({super.key, this.chatInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get friend info from constructor
    final extra = chatInfo;
    final conversationId = extra?['conversationId'] ?? '';
    final friendId = extra?['friendId'] ?? '';
    // final profileImage = extra?['profileImage'] ?? '';
    final lastSeen = extra?['lastSeen'] ?? '';
    final username = extra?['username'] ?? '';

    // Listen to live online status map
    final onlineMap = ref.watch(onlineStatusMapProvider);
    final isOnlineLive = onlineMap[friendId] ?? false;

    // Use live online status if available, else fallback to backend last seen
    final isOnlineToShow = isOnlineLive;
    final lastSeenToShow = isOnlineLive ? '' : lastSeen;

    final textController = useTextEditingController();
    final showEmojiPicker = useState(false);
    final ValueNotifier<String> message = useState('');
    final scrollController = useScrollController();
    final isLoadingMore = useState(false);

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

    void onMessageSent(MessageResponseModel messageModel) {
      // Add the new message to the messages state
      ref.read(messagesProvider.notifier).addMessage(messageModel);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    //Listen for new incoming WebSocket messages and merge them
    ref.listen<AsyncValue<ChatMessageModel?>>(
      privateMessagesProvider(friendId),
      (previous, next) {
        next.whenData((chatMessage) {
          if (chatMessage != null) {
            final messageModel = MessageResponseModel(
              messageId: Uuid().v4(),
              senderId: chatMessage.senderId,
              targetId: chatMessage.targetId,
              content: chatMessage.content,
              isRead: false,
              messageCreatedAt: DateTime.now(),
            );
            onMessageSent(messageModel);
          }
        });
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: ChatAppbarWidget(
          username: username,
          isOnline: isOnlineToShow,
          lastSeen: lastSeenToShow,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessagesRenderWidget(
              conversationId: conversationId,
              scrollController: scrollController,
            ),
          ),
          if (isLoadingMore.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            ),
          ChatInputFieldWidget(
            onMessageSent: onMessageSent,
            targetId: friendId,
            messageType: MessageType.private,
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
