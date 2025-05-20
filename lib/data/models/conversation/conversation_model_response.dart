import "../../../domain/entities/conversation/conversation_model.dart";

class ConversationResponseModel extends ConversationModel {
  ConversationResponseModel({
    required super.conversationId,
    required super.isGroup,
    required super.lastMessageContent,
    required super.lastMessageCreatedAt,
    required super.lastMessageId,
    required super.lastMessageSender,
    required super.name,
    required super.unReadCount,
  });

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationResponseModel(
      conversationId: json['conversation_id'],
      isGroup: json['is_group'],
      name: json['name'],
      lastMessageId: json['last_message_id'],
      lastMessageContent: json['last_message_content'],
      lastMessageSender: json['last_message_sender'],
      lastMessageCreatedAt: json['last_message_created_at'],
      unReadCount: json['unread_count'],
    );
  }
}
