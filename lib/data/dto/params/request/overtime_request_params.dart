part of '../../../data.dart';

/// Overtime Request Parameters
class OvertimeRequestParams extends BaseRequestParams {
  const OvertimeRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.overtimeType,
    this.date,
    this.startTime,
    this.endTime,
  });

  final OvertimeType overtimeType;
  final String? date;
  final String? startTime;
  final String? endTime;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.overtime;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'subcategory': overtimeType.name,
      "overtime_date": date,
      "overtime_start_time": startTime,
      "overtime_end_time": endTime,
    };
  }
}
