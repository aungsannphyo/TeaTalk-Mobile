import '../../../data/models/common_response_model.dart';
import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../data/models/conversation/conversation_response_model.dart';
import '../../events/create_conversation_key_event.dart';
import '../../events/get_conversation_event.dart';

abstract class ConversationRepository {
  Future<List<ChatListResponseModel>> getChatList();
  Future<ConversationResponseModel> getConversation(GetConversationEvent event);
  Future<CommonResponseModel> createConversationKey(
      CreateConversationKeyEvent event);
}
