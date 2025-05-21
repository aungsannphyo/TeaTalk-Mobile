import '../../../domain/entities/friend/frient_request_log_model.dart';

class FriendRequestLogResponseModel extends FrientRequestLogModel {
  FriendRequestLogResponseModel({
    required super.requestId,
    required super.senderId,
    required super.email,
    required super.username,
    required super.createAt,
    super.profileImage,
  });

  factory FriendRequestLogResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestLogResponseModel(
      requestId: json["requestId"],
      senderId: json["senderId"],
      email: json["email"],
      username: json["username"],
      createAt: json["createAt"],
      profileImage: json["profileImage"],
    );
  }
}
