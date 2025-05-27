import '../../../data/datasources/conversation/conversation_remote_datasource.dart';
import '../../../domain/repositories/conversation/conversation_repository.dart';
import '../../models/conversation/conversation_model_response.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSourceImpl remote;

  ConversationRepositoryImpl(this.remote);

  @override
  Future<List<ConversationResponseModel>> getConversations(String userID) {
    return remote.getConversations(userID);
  }
}
