import '../../../domain/repositories/message/message_repository.dart';
import '../../datasources/message/message_remote_datasource.dart';
import '../../models/message/message_model_response.dart';

class MessageRepositoryImpl extends MessageRepository {
  final MessageRemoteDatasource remote;
  MessageRepositoryImpl(this.remote);
  @override
  Future<List<MessageResponseModel>> getMessages(
      String conversationID, DateTime? cursorTime) {
    return remote.getMessages(conversationID, cursorTime);
  }
}
