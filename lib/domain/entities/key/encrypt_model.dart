import 'dart:typed_data';

class EncryptModel {
  final Uint8List cipherText;
  final Uint8List nonce;

  EncryptModel({required this.cipherText, required this.nonce});
}
