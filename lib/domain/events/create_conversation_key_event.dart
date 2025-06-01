import 'dart:convert';
import 'dart:typed_data';

class CreateConversationKeyEvent {
  final String conversationId;
  final String userId;
  final Uint8List conversationEncryptedKey;
  final Uint8List conversationKeyNonce;

  CreateConversationKeyEvent({
    required this.conversationId,
    required this.userId,
    required this.conversationEncryptedKey,
    required this.conversationKeyNonce,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'conversationEncryptedKey': base64Encode(conversationEncryptedKey),
      'conversationKeyNonce': base64Encode(conversationKeyNonce),
    };
  }
}
