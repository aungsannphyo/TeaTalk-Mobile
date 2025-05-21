class SearchUserModel {
  final String id;
  final String username;
  final String userIdentity;
  final String email;
  final bool isFriend;
  final String? profileImage;

  SearchUserModel({
    required this.id,
    required this.email,
    required this.userIdentity,
    required this.username,
    required this.isFriend,
    this.profileImage,
  });
}
