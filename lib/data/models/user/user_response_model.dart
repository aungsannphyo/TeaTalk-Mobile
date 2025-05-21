import '../../../domain/entities/user/user_model.dart';

class UserResponseModel extends UserModel {
  UserResponseModel({
    required super.id,
    required super.email,
    required super.userIdentity,
    required super.username,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'],
      email: json['email'],
      userIdentity: json['user_identity'],
      username: json['username'],
    );
  }
}
