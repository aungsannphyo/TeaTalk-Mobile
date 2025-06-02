import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../data/models/conversation/conversation_response_model.dart';
import '../../events/get_conversation_event.dart';

abstract class ConversationRepository {
  Future<List<ChatListResponseModel>> getChatList();
  Future<ConversationResponseModel> getConversation(GetConversationEvent event);
}
