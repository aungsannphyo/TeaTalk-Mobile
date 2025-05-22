import '../user/user_tile_model.dart';

class FriendModel implements UserTileModel {
  @override
  final String id;
  @override
  final String username;
  @override
  final String userIdentity;
  @override
  final String email;
  @override
  final String? profileImage;
  @override
  final bool isOnline;
  @override
  final String lastSeen;

  FriendModel({
    required this.id,
    required this.email,
    required this.userIdentity,
    required this.username,
    this.profileImage,
    required this.isOnline,
    required this.lastSeen,
  });

  @override
  bool get isFriend => true;
}
