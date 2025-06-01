class MessageModel {
  final String messageId;
  final String targetId;
  final String senderId;
  final String content;
  final bool isRead;
  final String? seenByName;
  final DateTime messageCreatedAt;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.targetId,
    required this.content,
    this.isRead = false,
    this.seenByName,
    required this.messageCreatedAt,
  });
}
