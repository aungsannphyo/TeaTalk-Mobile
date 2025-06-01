import 'dart:convert';
import 'dart:typed_data';

class RegisterEvent {
  final String username;
  final String email;
  final String password;
  final Uint8List salt;
  final Uint8List encryptedUserKey;
  final Uint8List userKeyNonce;

  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.salt,
    required this.encryptedUserKey,
    required this.userKeyNonce,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'salt': base64Encode(salt),
      'encryptedUserKey': base64Encode(encryptedUserKey),
      'userKeyNonce': base64Encode(userKeyNonce)
    };
  }
}
