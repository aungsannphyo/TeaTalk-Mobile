class MessageModel {
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isRead;
  final String? seenByName;
  final DateTime messageCreatedAt;

  MessageModel({
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.isRead = false,
    this.seenByName,
    required this.messageCreatedAt,
  });
}
