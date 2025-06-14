import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/common_response_model.dart';
import '../../models/auth/login_response_model.dart';
import "../../../exceptions/app_exception.dart";
import "../../../domain/events/register_event.dart";

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<CommonResponseModel> register(RegisterEvent register);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final apiUrl = dotenv.env['API_URL'];
  @override
  Future<LoginResponseModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw AppException(
          "Oops! That email or password doesn’t match our records.", 401);
    } else if (response.statusCode == 400) {
      final String field = data['fields'][0]['field'];
      if (field == "email") {
        throw AppException("Please enter a valid email address.", 400);
      } else {
        throw AppException("Please enter a  email address.", 400);
      }
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

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
      final String field = data['fields'][0]['field'];
      if (field == "email") {
        throw AppException("Please enter a valid email address.", 400);
      } else {
        throw AppException("Please enter a  email address.", 400);
      }
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
