import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../exceptions/app_exception.dart';
import '../../models/conversation/conversation_model_response.dart';

abstract class ConversationRemoteDatasource {
  Future<List<ConversationResponseModel>> getConversations(String userID);
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  ConversationRemoteDataSourceImpl({
    required this.token,
  });

  @override
  Future<List<ConversationResponseModel>> getConversations(
      String userID) async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/$userID/chat-list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List)
          .map((json) => ConversationResponseModel.fromJson(json))
          .toList();
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
