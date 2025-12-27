part of '../../../../data.dart';

/// Employment Response Parameters
class EmploymentRequestEntity extends BaseResponseParams {
  EmploymentRequestEntity({
    super.slug,
    super.requestingUser,
    super.currentReviewer,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
    required this.jobTitle,
    required this.organizationalUnit,
    required this.cooperationType,
    this.workloadType,
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

  final String jobTitle;
  final String organizationalUnit;
  final EmploymentCooperationType cooperationType;
  final WorkloadType? workloadType;
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

  factory EmploymentRequestEntity.fromJson(final String str) => EmploymentRequestEntity.fromMap(json.decode(str));

  factory EmploymentRequestEntity.fromMap(final Map<String, dynamic> json) => EmploymentRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers: json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.employment,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        cooperationType: EmploymentCooperationType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? EmploymentCooperationType.values.first,
        workloadType: WorkloadType.values.firstWhereOrNull((final e) => e.name == json["workload"]),
        jobTitle: json["job_title"] ?? "",
        organizationalUnit: json["organizational_unit"] ?? "",
        workLocation: EmploymentWorkLocation.values.firstWhereOrNull((final e) => e.name == json["work_location"]) ?? EmploymentWorkLocation.values.first,
        requiredPersonnelCount: json["required_employees_count"] ?? 0,
        jobSummary: json["job_summary"] ?? "",
        mainResponsibilities: json["main_responsibilities"] != null ? List<String>.from(json["main_responsibilities"]) : [],
        reportsTo: json["reports_to"] ?? "",
        requiredEducation: EducationType.values.firstWhereOrNull((final e) => e.name == json["required_education"]) ?? EducationType.values.first,
        preferredFieldOfStudy: json["preferred_major"],
        minimumExperience: json["minimum_experience"],
        technicalSkills: json["technical_skills"] != null ? List<String>.from(json["technical_skills"]) : null,
        softSkills: json["soft_skills"] != null ? List<String>.from(json["soft_skills"]) : null,
        requiredLanguages: json["required_languages"] != null ? List<String>.from(json["required_languages"]) : null,
      );

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
