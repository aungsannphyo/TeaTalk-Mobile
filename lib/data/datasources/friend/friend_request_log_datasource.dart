import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../exceptions/app_exception.dart';
import '../../models/friend/friend_request_log_response_model.dart';

abstract class FriendRequestLogDatasource {
  Future<List<FriendRequestLogResponseModel>> getAllFriendRequestLog(
      String userId);
}

class FriendRequestLogDatasourceImpl implements FriendRequestLogDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  FriendRequestLogDatasourceImpl({
    required this.token,
  });

  @override
  Future<List<FriendRequestLogResponseModel>> getAllFriendRequestLog(
      String userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/friend/requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((json) => FriendRequestLogResponseModel.fromJson(json))
          .toList();
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
