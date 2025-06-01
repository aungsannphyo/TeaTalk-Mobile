import 'user_tile_model.dart';

class SearchUserModel implements UserTileModel {
  @override
  final String id;
  @override
  final String username;
  @override
  final String userIdentity;
  @override
  final String email;
  @override
  final bool isFriend;
  @override
  final String? profileImage;
  @override
  final bool isOnline;
  @override
  final String lastSeen;

  SearchUserModel({
    required this.id,
    required this.email,
    required this.userIdentity,
    required this.username,
    required this.isFriend,
    this.profileImage,
    required this.isOnline,
    required this.lastSeen,
  });
}
