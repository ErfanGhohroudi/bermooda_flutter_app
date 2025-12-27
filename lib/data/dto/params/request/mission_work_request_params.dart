part of '../../../data.dart';

/// Mission and Work Request Parameters
class MissionWorkRequestParams extends BaseRequestParams {
  const MissionWorkRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
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

  @override
  String toJson() => json.encode(toMap()).englishNumber();

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
