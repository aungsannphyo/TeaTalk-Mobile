import 'dart:typed_data';

class LoginModel {
  final String id;
  final String username;
  final String email;
  final String token;
  final Uint8List pdk;
  final Uint8List encryptedUserKey;
  final Uint8List userKeyNonce;

  LoginModel({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.pdk,
    required this.encryptedUserKey,
    required this.userKeyNonce,
  });
}
