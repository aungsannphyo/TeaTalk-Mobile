import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/common_response_model.dart';
import "../../../exceptions/app_exception.dart";
import "../../../domain/events/register_event.dart";
import '../../models/user/search_user_response_model.dart';

abstract class UserRemoteDataSource {
  Future<CommonResponseModel> register(RegisterEvent register);
  Future<List<SearchUserResponseModel>> searchUser(String searchInput);
  Future<CommonResponseModel> sendFriendRequest(String reveicerID);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  UserRemoteDataSourceImpl({
    required this.token,
  });

  @override
  Future<CommonResponseModel> register(RegisterEvent register) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': register.email,
        'password': register.password,
        'username': register.username,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return CommonResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      if (data['fields'] != null && data['fields'] is List) {
        throw AppException("Please enter a valid email address.", 400);
      } else if (data['error'] != null) {
        throw AppException(
            "That email is already registered. Try logging in instead.", 400);
      } else {
        throw AppException("Something went wrong. Please try again.", 400);
      }
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

  @override
  Future<List<SearchUserResponseModel>> searchUser(String searchInput) async {
    final response = await http.get(
      Uri.parse('$apiUrl/users/search?q=$searchInput'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((json) => SearchUserResponseModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      throw AppException("User information not found.", 404);
    }
    throw AppException("Something went wrong. Please try again.", 500);
  }

  @override
  Future<CommonResponseModel> sendFriendRequest(String receiverID) async {
    final response = await http.post(
      Uri.parse('$apiUrl/friends/requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'receiverId': receiverID}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CommonResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      throw AppException("You need to add receiver id.", 400);
    } else if (response.statusCode == 409) {
      throw AppException(data['error'], 409);
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
