class ChatListModel {
  final String conversationId;
  final bool isGroup;
  final String name;
  final String? lastMessageId;
  final String? lastMessageContent;
  final String? lastMessageSender;
  final String? lastMessageCreatedAt;
  final int unReadCount;
  final String? receiverId;
  final String? profileImage;
  final int totalOnline;
  final String? lastSeen;

  ChatListModel({
    required this.conversationId,
    required this.isGroup,
    required this.name,
    required this.unReadCount,
    required this.totalOnline,
    this.lastSeen,
    this.lastMessageSender,
    this.receiverId,
    this.profileImage,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageCreatedAt,
  });
}
