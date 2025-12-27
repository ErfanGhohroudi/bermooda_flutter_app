part of '../../../data.dart';

/// General Request Parameters
class GeneralRequestParams extends BaseRequestParams {
  const GeneralRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
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

  @override
  RequestCategoryType get categoryType => RequestCategoryType.general_requests;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

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
