part of '../../../data.dart';

enum FollowUpDataSource {
  crm,
  legal;

  bool get isLegal => this == FollowUpDataSource.legal;

  bool get isCrm => this == FollowUpDataSource.crm;
}

class FollowUpReadDto extends Equatable {
  const FollowUpReadDto({
    this.slug,
    this.crmCategoryId,
    this.legalDepartmentId,
    this.caseId,
    this.assignedUser,
    this.files = const [],
    this.isFollowed = false,
    this.isSuccessful,
    this.isDeleted = false,
    this.isDelayed = false,
    this.feedback,
    this.date,
    this.time,
    this.timer,
    this.customerData,
    this.caseData,
  });

  final String? slug;
  final UserReadDto? assignedUser;
  final List<MainFileReadDto> files;
  final bool isFollowed;
  final bool? isSuccessful;
  final bool isDeleted;
  final bool isDelayed;
  final String? feedback;
  final Jalali? date;
  final String? time;
  final TimerReadDto? timer;

  // Customers fields
  final String? crmCategoryId;
  final CustomerData? customerData;

  // Legal fields
  final String? legalDepartmentId;
  final int? caseId;
  final LegalCaseData? caseData;

  String? get mainSourceId => crmCategoryId ?? legalDepartmentId;

  FollowUpDataSource? get dataSourceType {
    if (customerData != null || crmCategoryId != null) {
      return FollowUpDataSource.crm;
    } else if (caseData != null || caseId != null) {
      return FollowUpDataSource.legal;
    }
    return null;
  }

  FollowUpReadDto copyWith({
    final UserReadDto? assignedUser,
    final List<MainFileReadDto>? files,
    final bool? isFollowed,
    final bool? isSuccessful,
    final bool? isDeleted,
    final bool? isDelayed,
    final String? feedback,
    final Jalali? date,
    final String? time,
    final TimerReadDto? timer,
    final CustomerData? customerData,
    final LegalCaseData? caseData,
  }) {
    return FollowUpReadDto(
      slug: slug,
      crmCategoryId: crmCategoryId,
      legalDepartmentId: legalDepartmentId,
      caseId: caseId,
      assignedUser: assignedUser ?? this.assignedUser,
      files: files ?? this.files,
      isFollowed: isFollowed ?? this.isFollowed,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isDeleted: isDeleted ?? this.isDeleted,
      isDelayed: isDelayed ?? this.isDelayed,
      feedback: feedback ?? this.feedback,
      date: date ?? this.date,
      time: time ?? this.time,
      timer: timer ?? this.timer,
      customerData: customerData ?? this.customerData,
      caseData: caseData ?? this.caseData,
    );
  }

  factory FollowUpReadDto.fromJson(final String str) => FollowUpReadDto.fromMap(json.decode(str));

  factory FollowUpReadDto.fromMap(final Map<String, dynamic> json) {
    final String? time = json["time_to_tracking"];
    Jalali? dateJalali;

    try {
      final String? dateString = json["date_to_tracking"]?.toString();
      if (dateString != null && dateString.isNotEmpty) {
        final date = dateString.trim().toJalali();
        dateJalali = date?.copyWith(
          hour: int.tryParse(time?.split(":").firstOrNull ?? '0') ?? 0,
          minute: int.tryParse(time?.split(":").lastOrNull ?? '0') ?? 0,
        );
      }
    } catch (e) {
      dateJalali = null;
    }

    return FollowUpReadDto(
      slug: json["slug"] ?? json["id"]?.toString(),
      crmCategoryId: json["group_crm_id_main"]?.toString(),
      legalDepartmentId: json["contract_board_id"]?.toString(),
      caseId: json["contract_case_id"] ?? json["contract_case"],
      assignedUser: json["tracker"] != null && (json["tracker"] is Map<String, dynamic>)
          ? UserReadDto.fromMap(json["tracker"])
          : json["tracker_detail"] != null && (json["tracker_detail"] is Map<String, dynamic>)
          ? UserReadDto.fromMap(json["tracker_detail"])
          : null,
      files: json["file"] != null || json["files"] != null
          ? List<MainFileReadDto>.from((json["file"] ?? json["files"])!.map((final x) => MainFileReadDto.fromMap(x)))
          : [],
      isFollowed: json["is_tracked"] ?? false,
      isSuccessful: json["is_successful"],
      isDeleted: json["is_deleted"] ?? false,
      isDelayed: json["is_delayed"] ?? false,
      feedback: json["feedback"],
      date: dateJalali,
      time: time,
      timer: json["timer"] == null ? null : TimerReadDto.fromMap(json["timer"]),
      customerData: json["customer_data"] == null ? null : CustomerData.fromMap(json["customer_data"]),
      caseData: json["contract_case_data"] == null ? null : LegalCaseData.fromMap(json["contract_case_data"]),
    );
  }

  @override
  List<Object?> get props {
    return [
      slug,
      crmCategoryId,
      assignedUser,
      files,
      isFollowed,
      isSuccessful,
      isDeleted,
      isDelayed,
      feedback,
      date,
      time,
      timer,
      customerData,
      caseData,
    ];
  }
}

class CustomerData extends CustomerReadDto {
  const CustomerData({
    super.id,
    super.fullNameOrCompanyName,
    super.amount,
    // super.currency,
    super.connectionType,
  });

  factory CustomerData.fromJson(final String str) => CustomerData.fromMap(json.decode(str));

  factory CustomerData.fromMap(final Map<String, dynamic> json) {
    return CustomerData(
      id: json["id"],
      fullNameOrCompanyName: json["fullname"],
      amount: json["sell_balance"],
      // currency: json["currency"] == null ? null : CurrencyUnitReadDto.fromMap(json["currency"]),
      connectionType: json["conection_type"] == null
          ? null
          : ConnectionType.values.firstWhereOrNull((final e) => e.name == json["conection_type"]),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      fullNameOrCompanyName,
      amount,
      // currency,
      connectionType,
    ];
  }
}

class LegalCaseData extends LegalCaseReadDto {
  const LegalCaseData({
    required super.id,
    super.title,
  });

  factory LegalCaseData.fromJson(final String str) => LegalCaseData.fromMap(json.decode(str));

  factory LegalCaseData.fromMap(final Map<String, dynamic> json) {
    return LegalCaseData(
      id: json["id"] ?? 0,
      title: json["title"],
    );
  }

  @override
  List<Object?> get props => [id, title];
}
