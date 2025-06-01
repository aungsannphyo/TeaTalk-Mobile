import '../../../domain/entities/friend/friend_model.dart';

class FriendResponseModel extends FriendModel {
  FriendResponseModel({
    required super.id,
    required super.email,
    required super.userIdentity,
    required super.username,
    super.profileImage,
    required super.isOnline,
    required super.lastSeen,
  });

  factory FriendResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendResponseModel(
      profileImage: json['profileImage'],
      id: json['id'],
      email: json['email'],
      userIdentity: json['userIdentity'],
      username: json['username'],
      isOnline: json["isOnline"],
      lastSeen: json['lastSeen'],
    );
  }
}
