import '../../../domain/entities/message/message.dart';

class MessageResponseModel extends MessageModel {
  MessageResponseModel({
    required super.conversationId,
    required super.senderId,
    required super.receiverId,
    required super.content,
    super.isRead = false,
    super.seenByName,
    required super.messageCreatedAt,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      isRead: json['isRead'] ?? false,
      seenByName: json['seenByName'],
      messageCreatedAt: DateTime.parse(json['messageCreatedAt']),
    );
  }
}
