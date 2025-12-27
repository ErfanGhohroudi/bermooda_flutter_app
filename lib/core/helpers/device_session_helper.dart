import 'package:dio/dio.dart';
import 'package:u/utilities.dart';

import '../services/secure_storage_service.dart';

class DeviceSessionHelper {
  static const _deviceIdKey = "device_id";

  /// Returns a unique device ID (persisted in SharedPreferences)
  static Future<String> _getOrCreateDeviceId() async {
    // final prefs = await SharedPreferences.getInstance();
    String? deviceId = await SecureStorageService.read(_deviceIdKey);

    if (deviceId == null) {
      deviceId = const Uuid().v4(); // generate UUID
      await SecureStorageService.write(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// Collect device + app info
  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    String platform = "";
    String deviceModel = "";
    String osVersion = "";

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      platform = "android";
      deviceModel = "${androidInfo.manufacturer} ${androidInfo.model}";
      osVersion = "Android ${androidInfo.version.release}";
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      platform = "ios";
      deviceModel = iosInfo.utsname.machine;
      osVersion = "iOS ${iosInfo.systemVersion}";
    } else {
      platform = Platform.operatingSystem;
      deviceModel = "unknown";
      osVersion = Platform.operatingSystemVersion;
    }

    return {
      "platform": platform,
      "device_model": deviceModel,
      "os_version": osVersion,
      "app_version": packageInfo.version,
    };
  }

  /// Send session to backend
  static Future<bool> registerSession({
    required final String accessToken,
    final String? humanReadableName,
    final String? pushToken,
  }) async {
    final deviceId = await _getOrCreateDeviceId();
    final deviceInfo = await _collectDeviceInfo();

    final body = {
      "device_id": deviceId,
      "platform": deviceInfo["platform"],
      "device_model": deviceInfo["device_model"],
      "os_version": deviceInfo["os_version"],
      "app_version": deviceInfo["app_version"],
      "human_readable_name": humanReadableName ?? "My Device",
      if (pushToken != null) "push_token": pushToken,
    };

    final res = await Dio().post(
      "https://your-backend.com/api/v1/sessions",
      options: Options(
        contentType: "application/json",
        headers: {
          "Authorization": await SecureStorageService.getAccessToken() ?? "",
        }
      ),
      data: jsonEncode(body),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }
}
/// example for use after register user
///
/// ```dart
/// void onLoginSuccess(final String accessToken) async {
///   final success = await DeviceSessionHelper.registerSession(
///     accessToken: accessToken,
///     humanReadableName: "عرفان - موبایل شخصی",
///   );
///
///   if (success) {
///     print("📲 Session registered successfully!");
///   } else {
///     print("⚠️ Failed to register session");
///   }
/// }
/// ```
