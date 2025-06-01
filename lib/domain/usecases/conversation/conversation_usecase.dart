import '../../../data/models/common_response_model.dart';
import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../data/models/conversation/conversation_response_model.dart';
import '../../events/create_conversation_key_event.dart';
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

  Future<CommonResponseModel> createConversationKey(
      CreateConversationKeyEvent event) {
    return repository.createConversationKey(event);
  }
}
