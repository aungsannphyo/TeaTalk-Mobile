enum MessageType { private, group }

class ChatMessage {
  final String content;
  final String targetId; // receiverId or groupId
  final MessageType type;

  ChatMessage({
    required this.content,
    required this.targetId,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    switch (type) {
      case MessageType.private:
        return {'receiverId': targetId, 'content': content};
      case MessageType.group:
        return {'groupId': targetId, 'content': content};
    }
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('receiverId')) {
      return ChatMessage(
        content: json['content'],
        targetId: json['receiverId'],
        type: MessageType.private,
      );
    } else if (json.containsKey('groupId')) {
      return ChatMessage(
        content: json['content'],
        targetId: json['groupId'],
        type: MessageType.group,
      );
    } else {
      throw Exception('Invalid message format');
    }
  }
}
