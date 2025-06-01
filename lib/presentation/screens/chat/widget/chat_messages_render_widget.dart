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
    final messagesState = ref.watch(messagesProvider);
    final authState = ref.watch(loginProvider);
    final currentUserId = authState.auth?.id;

    useEffect(() {
      Future.microtask(() {
        ref.read(messagesProvider.notifier).getMessages(conversationId, null);
      });
      return null;
    }, [authState.auth?.id]);

    if (messagesState.isLoading &&
        (messagesState.messageList == null ||
            messagesState.messageList!.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    final messages = (messagesState.messageList ?? [])
      ..sort(
        (a, b) => b.messageCreatedAt.compareTo(a.messageCreatedAt),
      );

    return ListView(
      key: ValueKey(messages.length),
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      reverse: true,
      children: [
        for (final message in messages)
          MessageBubbleWidget(
            text: message.content,
            isMe: message.senderId == currentUserId,
            time:
                DateFormat('h:mma').format(message.messageCreatedAt.toLocal()),
            isRead: message.isRead,
          ),
      ],
    );
  }
}
