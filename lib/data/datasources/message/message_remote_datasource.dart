import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/message/message_model_response.dart';

abstract class MessageRemoteDatasource {
  Future<List<MessageResponseModel>> getMessages();
}

class MessageRemoteDatasourceImpl extends MessageRemoteDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  MessageRemoteDatasourceImpl({
    required this.token,
  });

  @override
  Future<List<MessageResponseModel>> getMessages() {
    // TODO: implement getMessages
    throw UnimplementedError();
  }
}
