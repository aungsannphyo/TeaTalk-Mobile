import '../../../domain/entities/user/search_user_model.dart';

class SearchUserResponseModel extends SearchUserModel {
  SearchUserResponseModel({
    required super.id,
    required super.email,
    required super.userIdentity,
    required super.username,
    required super.isFriend,
    super.profileImage,
  });

  factory SearchUserResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchUserResponseModel(
      profileImage: json['profile_image'],
      id: json['id'],
      email: json['email'],
      userIdentity: json['user_identity'],
      username: json['username'],
      isFriend: json['is_friend'],
    );
  }
}
