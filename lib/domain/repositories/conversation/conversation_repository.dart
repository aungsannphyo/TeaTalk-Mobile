import '../../../data/models/conversation/conversation_model_response.dart';

abstract class ConversationRepository {
  Future<List<ConversationResponseModel>> getConversations(String userID);
}
