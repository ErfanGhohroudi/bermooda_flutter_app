import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:u/utils/local_storage.dart';
import 'package:u/utils/navigator.dart';
import 'package:get/get.dart';

import '../../view/modules/splash/splash_page.dart';
import '../constants.dart';
import '../core.dart';

class EncryptionService {
  static final _storage = const FlutterSecureStorage();
  static const _keyStorageKey = 'encryption_key';

  /// Generate or retrieve the encryption key from secure storage
  static Future<Key> _getKey() async {
    final savedKey = await _storage.read(key: _keyStorageKey);
    if (savedKey == null) {
      final newKey = Key.fromSecureRandom(32); // AES-256
      await _storage.write(key: _keyStorageKey, value: newKey.base64);
      return newKey;
    }
    return Key.fromBase64(savedKey);
  }

  /// Encrypt plain text using AES-GCM and return in base64 format: IV|cipher
  static Future<String> encrypt(final String plainText) async {
    try {
      final key = await _getKey();
      final iv = IV.fromSecureRandom(12); // 12 bytes is optimal for AES-GCM
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return '${iv.base64}|${encrypted.base64}';
    } catch (e, stack) {
      debugPrint('Encryption error: $e\n$stack');
      throw Exception('Encryption failed');
    }
  }

  /// Decrypt base64-formatted string: IV|cipher
  static Future<String> decrypt(final String encryptedText) async {
    try {
      final parts = encryptedText.split('|');
      if (parts.length != 2) {
        debugPrint('Malformed encrypted text: $encryptedText');
        throw Exception('Invalid encrypted format');
      }

      final key = await _getKey();
      final iv = IV.fromBase64(parts[0]);
      final encryptedData = parts[1];
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      return encrypter.decrypt64(encryptedData, iv: iv);
    } catch (e, stack) {
      _storage.deleteAll();
      ULocalStorage.set(AppConstants.isLogin, false);
      Get.find<Core>().clearWorkspaces();
      UNavigator.offAll(const SplashPage());
      debugPrint('Decryption error: $e\n$stack');
      throw Exception('Decryption failed');
    }
  }
}
