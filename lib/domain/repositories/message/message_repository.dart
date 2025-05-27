import '../../../data/models/message/message_model_response.dart';

abstract class MessageRepository {
  Future<List<MessageResponseModel>> getMessages();
}
