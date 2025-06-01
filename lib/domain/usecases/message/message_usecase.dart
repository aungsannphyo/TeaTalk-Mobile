import '../../../data/models/message/message_model_response.dart';
import '../../repositories/message/message_repository.dart';

class MessageUsecase {
  final MessageRepository repository;
  MessageUsecase(this.repository);

  Future<List<MessageResponseModel>> getMessages(
      String conversationID, DateTime? cursorTime) async {
    return repository.getMessages(conversationID, cursorTime);
  }
}
