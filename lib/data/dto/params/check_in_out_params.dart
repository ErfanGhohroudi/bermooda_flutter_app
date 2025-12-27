part of '../../data.dart';

class CheckInOutParams {
  CheckInOutParams({
    required this.type,
    required this.method,
    required this.lat,
    required this.long,
    required this.uuid,
  });

  final AttendanceModalType type;
  final AttendanceMethod method;
  final double lat;
  final double long;
  final String uuid;

  bool get isCheckIn => type == AttendanceModalType.check_in;

  bool get isCheckOut => type == AttendanceModalType.check_out;

  bool get isCheckInOrCheckOut => isCheckIn || isCheckOut;

  String? _getDeviceName() {
    String? name;
    UApp.name;
    if (UApp.isAndroid) {
      final deviceInfo = UApp.androidDeviceInfo;
      name = deviceInfo.name;
    } else if (UApp.isIos) {
      final IosDeviceInfo deviceInfo = UApp.iosDeviceInfo;
      name = deviceInfo.name;
    }
    return name;
  }

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() {
    switch (type) {
      case AttendanceModalType.check_in:
        return <String, dynamic>{
          "method": method.name,
          "location": {
            "latitude": lat,
            "longitude": long,
            // "address": "تهران، میدان آزادی" // اختیاری
          },
          "device_id": _getDeviceName(), // اختیاری
          "uuid": uuid,
        };
      case AttendanceModalType.check_out:
        return <String, dynamic>{
          "method": method.name,
          "continue_overtime": false,
          "location": {
            "latitude": lat,
            "longitude": long,
            // "address": "تهران، میدان آزادی",
          },
          "device_id": _getDeviceName(), // اختیاری
          "report": "",
          "uuid": uuid,
        };
    }

  }
}
