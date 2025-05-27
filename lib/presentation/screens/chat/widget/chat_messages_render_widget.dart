import 'package:flutter/material.dart';

import 'message_bubble_widget.dart';

class ChatMessagesRenderWidget extends StatelessWidget {
  final ScrollController scrollController;

  const ChatMessagesRenderWidget({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      reverse: true,
      children: [
        MessageBubbleWidget(
          text: 'Hello! How are you?',
          isMe: false,
          time: '09:00',
          isRead: false,
        ),
        MessageBubbleWidget(
          text: 'I am good, thanks! And you?',
          isMe: true,
          time: '09:01',
          isRead: true,
        ),
        MessageBubbleWidget(
          text: 'Doing well! Ready for our meeting?',
          isMe: false,
          time: '09:02',
          isRead: false,
        ),
        // ... more sample messages ...
      ],
    );
  }
}
