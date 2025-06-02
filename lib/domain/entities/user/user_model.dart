import '../../../utils/gender.dart';

class User {
  final String userId;
  final String userIdentity;
  final String username;
  final String email;

  User({
    required this.email,
    required this.userId,
    required this.userIdentity,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      userIdentity: json['userIdentity'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class Details {
  final Gender? gender;
  final String? dateOfBirth;
  final String? bio;
  final String? profileImage;
  final bool isOnline;

  Details({
    this.gender,
    this.dateOfBirth,
    this.bio,
    this.profileImage,
    required this.isOnline,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      gender: json['gender'] != null
          ? genderFromApiString(json['gender'])
          : json['gender'],
      dateOfBirth: json['dateOfBirth'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      isOnline: json['isOnline'],
    );
  }
}

class UserModel {
  final User user;
  final Details details;

  UserModel({
    required this.user,
    required this.details,
  });
}
