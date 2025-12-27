import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../functions/user_functions.dart';
import 'encryption_service.dart';

class SecureStorageService {
  // Instance of FlutterSecureStorage for secure data storage
  static final _storage = const FlutterSecureStorage();

  /// Write a [String] value in secure storage with [key].
  static Future<void> write(final String key, final String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read value from secure storage with [key].
  static Future<String?> read(final String key) async {
    final value = await _storage.read(key: key);
    return value;
  }

  /// Delete value from secure storage with [key].
  static Future<void> delete(final String key) async {
    await _storage.delete(key: key);
  }

  /// Access Token -----------------------------------------------------------------------------------------
  /// Save Access Token in an encrypted format
  static Future<void> saveAccessToken(final String bearerToken) async {
    // Encrypt the token with a "Bearer " prefix
    final encryptedToken = await EncryptionService.encrypt("Bearer $bearerToken");
    // Store the encrypted token in secure storage with the key 'access_token'
    await _storage.write(key: 'access_token', value: encryptedToken);
  }

  /// Retrieve and decrypt the Access Token
  static Future<String?> getAccessToken() async {
    try {
      // Read the encrypted token from secure storage
      final encryptedToken = await _storage.read(key: 'access_token');
      if (encryptedToken != null) {
        // Decrypt the token and return it
        return EncryptionService.decrypt(encryptedToken);
      }
    } catch (e) {
      // Handle any errors during retrieval or decryption
      debugPrint("Error retrieving Access Token: $e");
      return null;
    }
    // Return null if no token is found
    return null;
  }

  /// Delete the Access Token from secure storage
  static Future<void> deleteAccessToken() async {
    // Remove the token with the key 'access_token'
    await _storage.delete(key: 'access_token');
  }

  /// Refresh Token -----------------------------------------------------------------------------------------
  /// Save Refresh Token in an encrypted format
  static Future<void> saveRefreshToken(final String bearerToken) async {
    // Encrypt the token
    final encryptedToken = await EncryptionService.encrypt(bearerToken);
    // Store the encrypted token in secure storage with the key 'refresh_token'
    await _storage.write(key: 'refresh_token', value: encryptedToken);
  }

  /// Retrieve and decrypt the Refresh Token
  static Future<String?> getRefreshToken() async {
    try {
      // Read the encrypted token from secure storage
      final encryptedToken = await _storage.read(key: 'refresh_token');
      if (encryptedToken != null) {
        // Decrypt the token and return it
        return EncryptionService.decrypt(encryptedToken);
      }
    } catch (e) {
      // Handle any errors during retrieval or decryption
      debugPrint("Error retrieving Refresh Token: $e");
      logout();
      return null;
    }
    // Return null if no token is found
    return null;
  }

  /// Delete the Refresh Token from secure storage
  static Future<void> deleteRefreshToken() async {
    // Remove the token with the key 'refresh_token'
    await _storage.delete(key: 'refresh_token');
  }

  /// Chat Websocket Token -----------------------------------------------------------------------------------------
  /// Save Chat Websocket Token in an encrypted format
  static Future<void> saveChatWebsocketToken(final String bearerToken) async {
    // Encrypt the token
    final encryptedToken = await EncryptionService.encrypt(bearerToken);
    // Store the encrypted token in secure storage with the key 'chat_websocket_token'
    await _storage.write(key: 'chat_websocket_token', value: encryptedToken);
  }

  /// Retrieve and decrypt the Chat Websocket Token
  static Future<String?> getChatWebsocketToken() async {
    try {
      // Read the encrypted token from secure storage
      final encryptedToken = await _storage.read(key: 'chat_websocket_token');
      if (encryptedToken != null) {
        // Decrypt the token and return it
        return EncryptionService.decrypt(encryptedToken);
      }
    } catch (e) {
      // Handle any errors during retrieval or decryption
      debugPrint("Error retrieving Chat Websocket Token: $e");
      logout();
      return null;
    }
    // Return null if no token is found
    return null;
  }

  /// Delete the Chat Websocket Token from secure storage
  static Future<void> deleteChatWebsocketToken() async {
    // Remove the token with the key 'chat_websocket_token'
    await _storage.delete(key: 'chat_websocket_token');
  }

  /// Password -----------------------------------------------------------------------------------------
  /// Save password in an encrypted format
  static Future<void> savePassword(final String password) async {
    // Encrypt the password
    final encryptedPassword = await EncryptionService.encrypt(password);
    // Store the encrypted password in secure storage with the key 'password'
    await _storage.write(key: 'password', value: encryptedPassword);
  }

  /// Retrieve and decrypt the Password
  static Future<String?> getPassword() async {
    try {
      // Read the encrypted password from secure storage
      final encryptedToken = await _storage.read(key: 'password');
      if (encryptedToken != null) {
        // Decrypt the password and return it
        return EncryptionService.decrypt(encryptedToken);
      }
    } catch (e) {
      // Handle any errors during retrieval or decryption
      debugPrint("Error retrieving Refresh Token: $e");
      logout();
      return null;
    }
    // Return null if no password is found
    return null;
  }

  /// Delete the Password from secure storage
  static Future<void> deletePassword() async {
    // Remove the password with the key 'password'
    await _storage.delete(key: 'password');
  }
}
