import '../../../domain/entities/conversation/conversation_model.dart';

class ConversationResponseModel extends ConversationModel {
  ConversationResponseModel({
    required super.conversationId,
    required super.isGroup,
    required super.createdAt,
    super.createdBy,
    super.name,
  });

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationResponseModel(
      conversationId: json['conversationId'],
      isGroup: json['isGroup'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      name: json['name'],
    );
  }
}
