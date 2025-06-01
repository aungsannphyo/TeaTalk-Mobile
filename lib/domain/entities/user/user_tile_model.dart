abstract class UserTileModel {
  String get id;
  String get username;
  String get userIdentity;
  String get email;
  String? get profileImage;
  bool get isOnline;
  String get lastSeen; // as DateTime
  bool get isFriend;
}
