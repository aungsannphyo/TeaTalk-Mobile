import '../../../data/models/conversation/conversation_model_response.dart';
import '../../repositories/conversation/conversation_repository.dart';

class ConversationUsecase {
  final ConversationRepository repository;

  ConversationUsecase(this.repository);

  Future<List<ConversationResponseModel>> getConversations(
      String userID) async {
    return repository.getConversations(userID);
  }
}
