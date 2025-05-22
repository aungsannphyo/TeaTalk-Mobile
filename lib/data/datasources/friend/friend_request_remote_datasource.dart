import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../domain/events/decide_friend_request_event.dart';
import '../../../exceptions/app_exception.dart';
import '../../models/common_response_model.dart';
import '../../models/friend/friend_request_response_model.dart';

abstract class FriendRequestRemoteDatasource {
  Future<List<FriendRequestResponseModel>> getAllFriendRequestLog(
      String userId);
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event);
}

class FriendRequestRemoteDatasourceImpl
    implements FriendRequestRemoteDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  FriendRequestRemoteDatasourceImpl({
    required this.token,
  });

  @override
  Future<List<FriendRequestResponseModel>> getAllFriendRequestLog(
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
          .map((json) => FriendRequestResponseModel.fromJson(json))
          .toList();
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

  @override
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event) async {
    final response = await http.post(Uri.parse('$apiUrl/friend/decide-request'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "status": event.status,
          "friendRequestId": event.friendRequestId,
        }));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CommonResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      throw AppException("Friend Request ID not found", 400);
    } else if (response.statusCode == 403) {
      throw AppException(data['error'].toString(), 403);
    } else {
      throw AppException("Something went wrong, Please try again later", 500);
    }
  }
}
