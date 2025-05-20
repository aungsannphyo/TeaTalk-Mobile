import '../../entities/conversation/conversation_model.dart';

abstract class ConversationRepository {
  Future<List<ConversationModel>> getConversations(String userID);
}
