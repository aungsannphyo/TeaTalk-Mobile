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
  Future<SearchUserResponseModel> searchUser(String searchInput);
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
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CommonResponseModel.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);

      if (data['fields'] != null && data['fields'] is List) {
        throw AppException("Please enter a valid email address.");
      } else if (data['error'] != null) {
        throw AppException(
            "That email is already registered. Try logging in instead.");
      } else {
        throw AppException("Something went wrong. Please try again.");
      }
    } else {
      throw AppException("Something went wrong. Please try again.");
    }
  }

  @override
  Future<SearchUserResponseModel> searchUser(String searchInput) async {
    final response = await http.get(
      Uri.parse('$apiUrl/user/search?q=$searchInput'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SearchUserResponseModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw AppException("User information not found.");
    }
    throw AppException("Something went wrong. Please try again.");
  }
}
