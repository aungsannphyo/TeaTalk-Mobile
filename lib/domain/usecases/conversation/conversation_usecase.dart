import '../../../domain/repositories/conversation/conversation_repository.dart';

import '../../entities/conversation/conversation_model.dart';

class ConversationUsecase {
  final ConversationRepository repository;

  ConversationUsecase(this.repository);

  Future<List<ConversationModel>> getConversations(String userID) {
    return repository.getConversations(userID);
  }
}
