part of '../../../../data.dart';

/// General Response Parameters
class GeneralRequestEntity extends BaseResponseParams {
  GeneralRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
    required this.generalType,
    this.personalInfoType,
    this.currentValue,
    this.newValue,
    this.certificatePurpose,
    this.certificateLanguage,
    this.date,
    this.includeSalary,
    this.includePosition,
    this.targetOrganizationName,
    this.targetOrganizationAddress,
    this.introductionSubject,
    this.specialDetails,
    this.files,
    this.subcategory,
  });

  final GeneralType generalType;
  final PersonalInfoType? personalInfoType;
  final String? currentValue;
  final String? newValue;
  final String? certificatePurpose;
  final CertificateLanguage? certificateLanguage;
  final String? date;
  final bool? includeSalary;
  final bool? includePosition;
  final String? targetOrganizationName;
  final String? targetOrganizationAddress;
  final String? introductionSubject;
  final String? specialDetails;
  final List<MainFileReadDto>? files;
  final String? subcategory;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.general_requests;

  factory GeneralRequestEntity.fromJson(final String str) => GeneralRequestEntity.fromMap(json.decode(str));

  factory GeneralRequestEntity.fromMap(final Map<String, dynamic> json) => GeneralRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.general_requests,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        subcategory: json["subcategory"],
        generalType: GeneralType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? GeneralType.personal_info_change,
        personalInfoType: json["info_type"] == null ? null : PersonalInfoType.values.firstWhereOrNull((final e) => e.name == json["info_type"]),
        currentValue: json["current_value"],
        newValue: json["new_value"],
        certificatePurpose: json["certificate_purpose"],
        certificateLanguage: json["required_language"] == null ? null : CertificateLanguage.values.firstWhereOrNull((final e) => e.name == json["required_language"]),
        date: json["required_issue_date"] ?? json["required_issue_date_intro"],
        includeSalary: json["include_salary"],
        includePosition: json["include_position"],
        targetOrganizationName: json["destination_organization"],
        targetOrganizationAddress: json["destination_address"],
        introductionSubject: json["letter_subject"],
        specialDetails: json["special_qualifications"],
        files: json["supporting_documents"] == null ? null : (json["supporting_documents"] as List).map((final id) => MainFileReadDto(fileId: id)).toList(),
      );

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    final fileIds = files?.map((final file) => file.fileId).whereType<int>().toList();

    switch (generalType) {
      case GeneralType.personal_info_change:
        return {
          ...baseMap,
          'subcategory': generalType.name,
          'info_type': personalInfoType?.name,
          'current_value': currentValue,
          'new_value': newValue,
          'supporting_document_id_list': fileIds,
        };

      case GeneralType.employment_certificate:
        return {
          ...baseMap,
          'subcategory': generalType.name,
          'certificate_purpose': certificatePurpose,
          'required_language': certificateLanguage?.name,
          'required_issue_date': date,
          'include_salary': includeSalary,
          'include_position': includePosition,
        };

      case GeneralType.introduction_letter:
        return {
          ...baseMap,
          'subcategory': generalType.name,
          'destination_organization': targetOrganizationName,
          'destination_address': targetOrganizationAddress,
          'letter_subject': introductionSubject,
          'required_issue_date_intro': date,
          'special_qualifications': specialDetails,
        };
    }
  }
}
