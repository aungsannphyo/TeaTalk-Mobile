enum MessageType { private, group }

class ChatMessageModel {
  final String senderId;
  final String content;
  final String targetId; // receiverId or groupId
  final MessageType type;

  ChatMessageModel({
    required this.senderId,
    required this.content,
    required this.targetId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    switch (type) {
      case MessageType.private:
        return {
          'receiverId': targetId,
          'content': content,
          'senderId': senderId
        };
      case MessageType.group:
        return {
          'groupId': targetId,
          'content': content,
          'senderId': senderId,
        };
    }
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('receiverId')) {
      return ChatMessageModel(
        senderId: json['senderId'],
        content: json['content'],
        targetId: json['receiverId'],
        type: MessageType.private,
      );
    } else if (json.containsKey('groupId')) {
      return ChatMessageModel(
        senderId: json['senderId'],
        content: json['content'],
        targetId: json['groupId'],
        type: MessageType.group,
      );
    } else {
      throw Exception('Invalid message format');
    }
  }
}
