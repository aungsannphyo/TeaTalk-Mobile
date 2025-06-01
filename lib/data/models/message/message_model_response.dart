import '../../../domain/entities/message/message.dart';

class MessageResponseModel extends MessageModel {
  MessageResponseModel({
    required super.targetId,
    required super.senderId,
    required super.messageId,
    required super.content,
    super.isRead = false,
    super.seenByName,
    required super.messageCreatedAt,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      messageId: json['messageId'],
      senderId: json['senderId'],
      targetId: json['targetId'],
      content: json['content'],
      isRead: json['isRead'] ?? false,
      seenByName: json['seenByName'] ?? '',
      messageCreatedAt: DateTime.parse(
        json['messageCreatedAt'],
      ),
    );
  }
}
