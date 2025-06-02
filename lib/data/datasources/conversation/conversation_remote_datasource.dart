import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../domain/events/get_conversation_event.dart';
import '../../../exceptions/app_exception.dart';
import '../../models/conversation/chat_list_response_model.dart';
import '../../models/conversation/conversation_response_model.dart';

abstract class ConversationRemoteDatasource {
  Future<List<ChatListResponseModel>> getChatList();
  Future<ConversationResponseModel> getConversation(
    GetConversationEvent event,
  );
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  ConversationRemoteDataSourceImpl({
    required this.token,
  });

  @override
  Future<List<ChatListResponseModel>> getChatList() async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/chat-list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((json) => ChatListResponseModel.fromJson(json))
          .toList();
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

  @override
  Future<ConversationResponseModel> getConversation(
      GetConversationEvent event) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/conversations/sender/${event.senderId}/receiver/${event.receiverId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ConversationResponseModel.fromJson(data);
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
