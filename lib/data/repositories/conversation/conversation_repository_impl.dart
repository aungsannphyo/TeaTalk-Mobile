import '../../../data/datasources/conversation/conversation_remote_datasource.dart';

import '../../../domain/entities/conversation/conversation_model.dart';

import '../../../domain/repositories/conversation/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSourceImpl remote;

  ConversationRepositoryImpl(this.remote);

  @override
  Future<List<ConversationModel>> getConversations(String userID) {
    return remote.getConversations(userID);
  }
}
