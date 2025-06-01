import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:random_string/random_string.dart';

import '../domain/entities/key/encrypt_model.dart';

class CryptoHelper {
  static const int pbkdf2Iterations = 10000;
  static const int keyLength = 32; // 256 bits
  static const int sortLength = 16;
  static const int nonceLength = 12;

  /// Derive a key from password + salt using PBKDF2
  static Uint8List deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    final params = Pbkdf2Parameters(salt, pbkdf2Iterations, keyLength);
    pbkdf2.init(params);

    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  /// Generate random bytes for nonce or key
  static Uint8List generateRandomBytes(int length) {
    final rnd = SecureRandom("Fortuna")..seed(KeyParameter(_seed()));
    return rnd.nextBytes(length);
  }

  static Uint8List _seed() {
    final seedSource = randomAlphaNumeric(32);
    return Uint8List.fromList(utf8.encode(seedSource));
  }

  /// Encrypt plaintext with AES-GCM, returns (ciphertext, nonce)
  static EncryptModel encrypt(Uint8List plaintext, Uint8List key, int length) {
    final nonce = generateRandomBytes(length); // 12 bytes recommended for GCM
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );
    final cipherText = cipher.process(plaintext);
    return EncryptModel(
      cipherText: cipherText,
      nonce: nonce,
    );
  }

  /// Decrypt ciphertext with AES-GCM using key + nonce
  static Uint8List decrypt(
      Uint8List cipherText, Uint8List nonce, Uint8List key) {
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );
    return cipher.process(cipherText);
  }
}
