class ConversationModel {
  final String conversationId;
  final bool isGroup;
  final String? name;
  final String? createdBy;
  final String createdAt;

  ConversationModel({
    required this.conversationId,
    required this.isGroup,
    required this.createdAt,
    this.createdBy,
    required this.name,
  });
}
