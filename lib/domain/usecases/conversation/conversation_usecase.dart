import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../data/models/conversation/conversation_response_model.dart';
import '../../events/get_conversation_event.dart';
import '../../repositories/conversation/conversation_repository.dart';

class ConversationUsecase {
  final ConversationRepository repository;

  ConversationUsecase(this.repository);

  Future<List<ChatListResponseModel>> getChatList() async {
    return repository.getChatList();
  }

  Future<ConversationResponseModel> getConversation(
      GetConversationEvent event) {
    return repository.getConversation(event);
  }
}
