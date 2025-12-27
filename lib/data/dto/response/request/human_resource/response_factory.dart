part of '../../../../data.dart';

/// Factory class for creating response models from API responses
class RequestEntityFactory {
  /// Creates appropriate response model based on request type
  static IRequestReadDto createResponseFromMap(final Map<String, dynamic> json) {
    final requestType = RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]);

    if (requestType == null) {
      throw ArgumentError('Unknown request type: ${json["main_category"]}');
    }

    switch (requestType) {
      case RequestCategoryType.employment:
        return EmploymentRequestEntity.fromMap(json);

      case RequestCategoryType.overtime:
        return OvertimeRequestEntity.fromMap(json);

      case RequestCategoryType.general_requests:
        return GeneralRequestEntity.fromMap(json);

      case RequestCategoryType.leave_attendance:
        return LeaveAttendanceRequestEntity.fromMap(json);

      case RequestCategoryType.missions_work:
        return MissionWorkRequestEntity.fromMap(json);

      case RequestCategoryType.support_logistics:
        return SupportProcurementRequestEntity.fromMap(json);

      case RequestCategoryType.welfare_financial:
        return WelfareFinancialRequestEntity.fromMap(json);
    }
  }

  /// Creates appropriate response model from JSON string
  static IRequestReadDto createResponseFromJson(final String jsonString) {
    return createResponseFromMap(json.decode(jsonString));
  }

  /// Creates list of response models from list of maps
  static List<IRequestReadDto> createResponseListFromMaps(final List<dynamic> jsonList) {
    return jsonList.map((final json) => createResponseFromMap(json)).toList();
  }

  /// Creates list of response models from JSON string containing array
  static List<IRequestReadDto> createResponseListFromJson(final String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>().map((final json) => createResponseFromMap(json)).toList();
  }
}
