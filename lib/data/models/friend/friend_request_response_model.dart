import '../../../domain/entities/friend/frient_request_model.dart';

class FriendRequestResponseModel extends FrientRequestModel {
  FriendRequestResponseModel({
    required super.requestId,
    required super.senderId,
    required super.email,
    required super.username,
    required super.createAt,
    super.profileImage,
  });

  factory FriendRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestResponseModel(
      requestId: json["requestId"],
      senderId: json["senderId"],
      email: json["email"],
      username: json["username"],
      createAt: json["createAt"],
      profileImage: json["profileImage"],
    );
  }
}
