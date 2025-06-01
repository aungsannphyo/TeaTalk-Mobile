import "../../../domain/entities/conversation/chat_list_model.dart";

class ChatListResponseModel extends ChatListModel {
  ChatListResponseModel({
    required super.conversationId,
    required super.isGroup,
    required super.lastMessageContent,
    required super.lastMessageCreatedAt,
    required super.lastMessageId,
    required super.lastMessageSender,
    required super.name,
    required super.unReadCount,
    required super.receiverId,
    required super.profileImage,
    required super.totalOnline,
    required super.lastSeen,
  });

  factory ChatListResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatListResponseModel(
      conversationId: json['conversationId'],
      isGroup: json['isGroup'],
      name: json['name'],
      lastMessageId: json['lastMessageId'],
      lastMessageContent: json['lastMessageContent'],
      lastMessageSender: json['lastMessageSender'],
      lastMessageCreatedAt: json['lastMessageCreatedAt'],
      unReadCount: json['unreadCount'],
      receiverId: json['receiverId'],
      profileImage: json['image'],
      totalOnline: json['totalOnline'],
      lastSeen: json['lastSeen'],
    );
  }
}
