import '../../../domain/entities/auth/login_model.dart';

class LoginResponseModel extends LoginModel {
  LoginResponseModel({
    required super.id,
    required super.email,
    required super.username,
    required super.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      token: json['token'],
    );
  }
}
