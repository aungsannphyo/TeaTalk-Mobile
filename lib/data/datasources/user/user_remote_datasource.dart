import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../domain/events/update_personal_details_event.dart';
import '../../models/common_response_model.dart';
import "../../../exceptions/app_exception.dart";
import "../../../domain/events/register_event.dart";
import '../../models/user/search_user_response_model.dart';
import '../../models/user/user_response_model.dart';

abstract class UserRemoteDataSource {
  Future<CommonResponseModel> register(RegisterEvent register);
  Future<List<SearchUserResponseModel>> searchUser(String searchInput);
  Future<CommonResponseModel> sendFriendRequest(String reveicerID);
  Future<CommonResponseModel> uploadProfileImage(File imageFile);
  Future<CommonResponseModel> updateUserPersonalDetails(
      UpdatePersonalDetailsEvent event);
  Future<UserResponseModel> getUser();
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
      body: jsonEncode(register.toJson()),
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

  @override
  Future<CommonResponseModel> uploadProfileImage(File imageFile) async {
    final uri = Uri.parse('$apiUrl/users/upload-profile-image');
    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';
    final mimeType =
        lookupMimeType(imageFile.path) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
      'profileImage',
      imageFile.path,
      contentType: MediaType(mimeParts[0], mimeParts[1]),
    );
    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final data = json.decode(responseBody);
    if (streamedResponse.statusCode == 200) {
      return CommonResponseModel.fromJson(data);
      // Optionally parse response.stream to read response body
    } else if (streamedResponse.statusCode == 400) {
      throw AppException("You need to upload image", 400);
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

  @override
  Future<CommonResponseModel> updateUserPersonalDetails(
      UpdatePersonalDetailsEvent event) async {
    final response = await http.put(
      Uri.parse('$apiUrl/users/personal-details'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event.toJson()),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return CommonResponseModel.fromJson(data);
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }

  @override
  Future<UserResponseModel> getUser() async {
    final response = await http.get(
      Uri.parse('$apiUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserResponseModel.fromJson(data);
    } else {
      throw AppException("Something went wrong. Please try again.", 500);
    }
  }
}
