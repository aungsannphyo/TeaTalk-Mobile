import '../../../domain/entities/user/user_model.dart';

class UserResponseModel extends UserModel {
  UserResponseModel({
    required super.user,
    required super.details,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      user: User.fromJson(json['user']),
      details: Details.fromJson(json['personalDetails']),
    );
  }
}
