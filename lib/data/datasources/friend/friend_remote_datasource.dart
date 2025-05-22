import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../exceptions/app_exception.dart';
import '../../models/friend/friend_response_model.dart';

abstract class FriendDatasource {
  Future<List<FriendResponseModel>> getFriends();
}

class FriendRemoteDatasource implements FriendDatasource {
  final String? token;
  final apiUrl = dotenv.env['API_URL'];

  FriendRemoteDatasource({
    required this.token,
  });

  @override
  Future<List<FriendResponseModel>> getFriends() async {
    final response = await http.get(
      Uri.parse('$apiUrl/user/friend'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data as List)
          .map((json) => FriendResponseModel.fromJson(json))
          .toList();
    } else {
      throw AppException("Something went wrong, Please try again later", 500);
    }
  }
}
