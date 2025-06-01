class GetConversationEvent {
  final String senderId;
  final String receiverId;

  GetConversationEvent({
    required this.senderId,
    required this.receiverId,
  });
}
