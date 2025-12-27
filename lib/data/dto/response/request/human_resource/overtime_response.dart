part of '../../../../data.dart';

/// Support and Procurement Response Parameters
class OvertimeRequestEntity extends BaseResponseParams {
  OvertimeRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
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

  factory OvertimeRequestEntity.fromJson(final String str) => OvertimeRequestEntity.fromMap(json.decode(str));

  factory OvertimeRequestEntity.fromMap(final Map<String, dynamic> json) => OvertimeRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.support_logistics,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        overtimeType: OvertimeType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? OvertimeType.regular_day,
        date: json["overtime_date"],
        startTime: json["overtime_start_time"],
        endTime: json["overtime_end_time"],
      );

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'subcategory': overtimeType.name,
      'overtime_date': date,
      "overtime_start_time": startTime,
      "overtime_end_time": endTime,
    };
  }
}
