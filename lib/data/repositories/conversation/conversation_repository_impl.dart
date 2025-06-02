import '../../../data/datasources/conversation/conversation_remote_datasource.dart';
import '../../../domain/events/get_conversation_event.dart';
import '../../../domain/repositories/conversation/conversation_repository.dart';
import '../../models/conversation/chat_list_response_model.dart';
import '../../models/conversation/conversation_response_model.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSourceImpl remote;

  ConversationRepositoryImpl(this.remote);

  @override
  Future<List<ChatListResponseModel>> getChatList() {
    return remote.getChatList();
  }

  @override
  Future<ConversationResponseModel> getConversation(
      GetConversationEvent event) {
    return remote.getConversation(event);
  }
}
