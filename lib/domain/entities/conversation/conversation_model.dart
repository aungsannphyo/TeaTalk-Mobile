class ConversationModel {
  final String conversationId;
  final bool isGroup;
  final String name;
  final String lastMessageId;
  final String lastMessageContent;
  final String lastMessageSender;
  final String lastMessageCreatedAt;
  final int unReadCount;

  ConversationModel({
    required this.conversationId,
    required this.isGroup,
    required this.name,
    required this.lastMessageId,
    required this.lastMessageContent,
    required this.lastMessageCreatedAt,
    required this.unReadCount,
    required this.lastMessageSender,
  });
}
