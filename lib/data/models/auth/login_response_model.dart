import 'dart:convert';

import '../../../domain/entities/auth/login_model.dart';

class LoginResponseModel extends LoginModel {
  LoginResponseModel({
    required super.id,
    required super.email,
    required super.username,
    required super.token,
    required super.pdk,
    required super.encryptedUserKey,
    required super.userKeyNonce,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      token: json['token'],
      pdk: base64Decode(json['pdk']),
      encryptedUserKey: base64Decode(json['encryptedUserKey']),
      userKeyNonce: base64Decode(json['userKeyNonce']),
    );
  }
}
