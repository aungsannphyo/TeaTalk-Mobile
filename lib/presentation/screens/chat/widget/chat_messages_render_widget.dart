import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/auth/login_provider.dart';
import '../../../providers/message/message_provider.dart';
import 'message_bubble_widget.dart';

class ChatMessagesRenderWidget extends HookConsumerWidget {
  final String conversationId;
  final ScrollController scrollController;

  const ChatMessagesRenderWidget({
    super.key,
    required this.scrollController,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MessagesState messagesState = ref.watch(messagesProvider);
    final AuthState authState = ref.watch(loginProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(messagesProvider.notifier).getMessages(conversationId, null);
      });

      return null;
    }, [authState.auth]);

    bool isMe(String userId) {
      final currentUserId = authState.auth?.id;
      return currentUserId == userId;
    }

    // Check if messages are being fetched
    if (messagesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      reverse: true,
      children: [
        // Display loading indicator if messages are being fetched
        if (messagesState.isLoading)
          const Center(child: CircularProgressIndicator()),
        ...(messagesState.messageList ?? [])
            .where((message) =>
                // ignore: unnecessary_null_comparison
                message.isRead != null)
            .map((message) {
          return MessageBubbleWidget(
            text: message.content,
            isMe: isMe(message.senderId),
            // ignore: unnecessary_null_comparison
            time: message.messageCreatedAt != null
                ? DateFormat('h:mma').format(message.messageCreatedAt.toLocal())
                : '',
            isRead: message.isRead,
          );
        }),
      ],
    );
  }
}
