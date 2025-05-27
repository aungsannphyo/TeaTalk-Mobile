import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../exceptions/app_exception.dart';
import '../../models/message/message_model_response.dart';

abstract class MessageRemoteDatasource {
  Future<List<MessageResponseModel>> getMessages(
      String conversationID, DateTime? cursorTime);
}

class MessageRemoteDatasourceImpl extends MessageRemoteDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  MessageRemoteDatasourceImpl({
    required this.token,
  });

  @override
  Future<List<MessageResponseModel>> getMessages(
      String conversationID, DateTime? cursorTime) async {
    final queryParameters = <String, String>{};
    if (cursorTime != null) {
      queryParameters['cursorTime'] = cursorTime.toIso8601String();
    }

    final uri = Uri.parse('$apiUrl/messages/$conversationID')
        .replace(queryParameters: queryParameters);

    final http.Response response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MessageResponseModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw AppException('Unauthorized access. Please log in again.', 401);
    } else {
      throw AppException('Failed to load messages: ${response.reasonPhrase}',
          response.statusCode);
    }
  }
}
