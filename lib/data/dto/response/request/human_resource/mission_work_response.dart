part of '../../../../data.dart';

/// Mission and Work Response Parameters
class MissionWorkRequestEntity extends BaseResponseParams {
  MissionWorkRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
    required this.missionType,
    this.destination,
    this.exactLocation,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.missionPurpose,
    this.transportationType,
    this.needsAccommodation,
    this.accommodationType,
    this.companionNames,
    this.relatedMissionNumber,
    this.expenseType,
    this.expenseAmount,
    this.paymentMethod,
    this.files,
  });

  final MissionType missionType;
  final String? destination;
  final String? exactLocation;
  final String? startDate;
  final String? startTime;
  final String? endDate;
  final String? endTime;
  final MissionPurpose? missionPurpose;
  final TransportationType? transportationType;
  final bool? needsAccommodation;
  final AccommodationType? accommodationType;
  final String? companionNames;
  final String? relatedMissionNumber;
  final ExpenseType? expenseType;
  final String? expenseAmount;
  final PaymentMethod? paymentMethod;
  final List<MainFileReadDto>? files;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.missions_work;

  factory MissionWorkRequestEntity.fromJson(final String str) => MissionWorkRequestEntity.fromMap(json.decode(str));

  factory MissionWorkRequestEntity.fromMap(final Map<String, dynamic> json) => MissionWorkRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.missions_work,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        missionType: MissionType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? MissionType.out_of_city_mission,
        destination: json["mission_destination"],
        exactLocation: json["mission_exact_location"] ?? json["in_city_location"],
        startDate: _extractDate(json["mission_start_datetime"] ?? json["in_city_start_datetime"] ?? json["expense_date"]),
        startTime: _extractTime(json["mission_start_datetime"] ?? json["in_city_start_datetime"]),
        endDate: _extractDate(json["mission_end_datetime"] ?? json["in_city_end_datetime"]),
        endTime: _extractTime(json["mission_end_datetime"] ?? json["in_city_end_datetime"]),
        missionPurpose: json["mission_purpose"] == null ? null : MissionPurpose.values.firstWhereOrNull((final e) => e.name == json["mission_purpose"]),
        transportationType: json["transportation_type"] == null ? null : TransportationType.values.firstWhereOrNull((final e) => e.name == json["transportation_type"]),
        needsAccommodation: json["needs_accommodation"],
        accommodationType: json["accommodation_type"] == null ? null : AccommodationType.values.firstWhereOrNull((final e) => e.name == json["accommodation_type"]),
        companionNames: json["mission_companion"],
        relatedMissionNumber: json["related_mission_number"],
        expenseType: json["expense_type"] == null ? null : ExpenseType.values.firstWhereOrNull((final e) => e.name == json["expense_type"]),
        expenseAmount: json["expense_amount"],
        paymentMethod: json["payment_method"] == null ? null : PaymentMethod.values.firstWhereOrNull((final e) => e.name == json["payment_method"]),
        files: _extractFiles(json),
      );

  static String? _extractDate(final String? dateTime) {
    if (dateTime == null) return null;
    final parts = dateTime.split(' ');
    return parts.isNotEmpty ? parts[0] : null;
  }

  static String? _extractTime(final String? dateTime) {
    if (dateTime == null) return null;
    final parts = dateTime.split(' ');
    return parts.length > 1 ? parts[1] : null;
  }

  static List<MainFileReadDto>? _extractFiles(final Map<String, dynamic> json) {
    if (json["invitation_document"] != null && json["invitation_document"] != []) {
      return List<MainFileReadDto>.from(json["invitation_document"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    if (json["receipt_document"] != null && json["receipt_document"] != []) {
      return List<MainFileReadDto>.from(json["receipt_document"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    final fileIds = files?.map((final file) => file.fileId).whereType<int>().toList();

    switch (missionType) {
      case MissionType.out_of_city_mission:
        return {
          ...baseMap,
          'subcategory': missionType.name,
          'mission_destination': destination,
          'mission_exact_location': exactLocation,
          'mission_start_datetime': "$startDate $startTime",
          'mission_end_datetime': "$endDate $endTime",
          'mission_purpose': missionPurpose?.name,
          'transportation_type': transportationType?.name,
          'needs_accommodation': needsAccommodation ?? false,
          'accommodation_type': needsAccommodation == true ? accommodationType?.name : null,
          'mission_companion': companionNames,
          'invitation_document_ids': fileIds,
        };

      case MissionType.in_city_mission:
        return {
          ...baseMap,
          'subcategory': missionType.name,
          'in_city_location': exactLocation,
          'in_city_start_datetime': "$startDate $startTime",
          'in_city_end_datetime': "$endDate $endTime",
          'mission_purpose': missionPurpose?.name,
          'transportation_type': transportationType?.name,
        };

      case MissionType.mission_expense_payment:
        return {
          ...baseMap,
          'subcategory': missionType.name,
          'related_mission_number': relatedMissionNumber,
          'expense_type': expenseType?.name,
          'expense_date': startDate,
          'expense_amount': expenseAmount,
          'payment_method': paymentMethod?.name,
          'receipt_document_id_list': fileIds,
        };
    }
  }
}
