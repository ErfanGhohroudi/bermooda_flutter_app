part of '../../../data.dart';

/// Employment Request Parameters
class EmploymentRequestParams extends BaseRequestParams {
  const EmploymentRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.cooperationType,
    this.workloadType,
    required this.jobTitle,
    required this.organizationalUnit,
    required this.workLocation,
    required this.requiredPersonnelCount,
    required this.jobSummary,
    required this.mainResponsibilities,
    required this.reportsTo,
    required this.requiredEducation,
    this.preferredFieldOfStudy,
    this.minimumExperience,
    this.technicalSkills,
    this.softSkills,
    this.requiredLanguages,
  });

  final EmploymentCooperationType cooperationType;
  final WorkloadType? workloadType;
  final String jobTitle;
  final String organizationalUnit;
  final EmploymentWorkLocation workLocation;
  final int requiredPersonnelCount;
  final String jobSummary;
  final List<String> mainResponsibilities;
  final String reportsTo;
  final EducationType requiredEducation;
  final String? preferredFieldOfStudy;
  final int? minimumExperience;
  final List<String>? technicalSkills;
  final List<String>? softSkills;
  final List<String>? requiredLanguages;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.employment;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'subcategory': cooperationType.name,
      'workload': cooperationType != EmploymentCooperationType.outsourcing ? workloadType?.name : null,
      'job_title': jobTitle,
      'organizational_unit': organizationalUnit,
      'work_location': workLocation.name,
      'required_employees_count': requiredPersonnelCount,
      'job_summary': jobSummary,
      'main_responsibilities': mainResponsibilities,
      'reports_to': reportsTo,
      'required_education': requiredEducation.name,
      'preferred_major': preferredFieldOfStudy,
      'minimum_experience': minimumExperience,
      'technical_skills': technicalSkills,
      'soft_skills': softSkills,
      'required_languages': requiredLanguages,
    };
  }
}
