part of '../../data.dart';

class CreateMemberParams {
  String? phoneNumber;
  String? folderSlug;
  String? workShiftSlug;
  String? firstName;
  String? lastName;
  List<PermissionReadDto>? permissions;
  bool moreInformation;
  int? stateId;
  int? cityId;
  String? email;
  String? dateOfBirthJalali;
  String? nationalCode;
  String? certificateNumber;
  GenderType? gender;
  String? address;
  String? postalCode;
  bool? marriage;
  int? numberOfChildren;
  String? shabaNumber;
  String? dateOfStartToWorkJalali; // 1400/01/01
  String? contractEndDateJalali; // 1400/01/01
  String? jobPosition;
  int? studyCategoryId;
  bool isEmergencyInformation;
  String? emergencyFirstName;
  String? emergencyLastName;
  String? emergencyPhoneNumber;
  String? emergencyRelationship;
  int? badRecordId;
  MilitaryStatus? militaryStatus;
  InsuranceType? insuranceType;
  EducationType? educationType;
  EmploymentType? employmentType;
  SalaryType? salaryType;
  List<String>? favorites;
  List<String>? skills;

  CreateMemberParams({
    this.phoneNumber,
    this.folderSlug,
    this.workShiftSlug,
    this.firstName,
    this.lastName,
    this.permissions,
    this.moreInformation = false,
    this.stateId,
    this.cityId,
    this.email,
    this.dateOfBirthJalali,
    this.nationalCode,
    this.certificateNumber,
    this.gender,
    this.address,
    this.postalCode,
    this.marriage,
    this.numberOfChildren,
    this.shabaNumber,
    this.dateOfStartToWorkJalali,
    this.contractEndDateJalali,
    this.jobPosition,
    this.studyCategoryId,
    this.isEmergencyInformation = false,
    this.emergencyFirstName,
    this.emergencyLastName,
    this.emergencyPhoneNumber,
    this.emergencyRelationship,
    this.badRecordId,
    this.militaryStatus,
    this.insuranceType,
    this.educationType,
    this.employmentType,
    this.salaryType,
    this.favorites,
    this.skills,
  });

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "phone_number": phoneNumber,
        "folder_slug": folderSlug,
        "workshift_slug": workShiftSlug,
        "first_name": firstName,
        "last_name": lastName,
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((final x) => x.toMap())),
        "more_information": moreInformation,
        "state_id": moreInformation ? stateId : null,
        "city_id": moreInformation ? cityId : null,
        "email": moreInformation ? email : null,
        "date_of_birth_jalali": moreInformation ? dateOfBirthJalali : null,
        "national_code": moreInformation ? nationalCode : null,
        "certificate_number": moreInformation ? certificateNumber : null,
        "gender": moreInformation ? gender?.name : null,
        "address": moreInformation ? address : null,
        "postal_code": moreInformation ? postalCode : null,
        "marriage": marriage,
        "number_of_children": numberOfChildren ?? 0,
        "shaba_number": moreInformation ? shabaNumber : null,
        "date_of_start_to_work_jalali": moreInformation ? dateOfStartToWorkJalali : null,
        "contract_end_date_jalali": moreInformation ? contractEndDateJalali : null,
        "job_position": moreInformation ? jobPosition : null,
        "study_category_id": moreInformation ? studyCategoryId : null,
        "is_emergency_information": moreInformation ? isEmergencyInformation : false,
        "emergency_first_name": moreInformation && isEmergencyInformation ? emergencyFirstName : null,
        "emergency_last_name": moreInformation && isEmergencyInformation ? emergencyLastName : null,
        "emergency_phone_number": moreInformation && isEmergencyInformation ? emergencyPhoneNumber : null,
        "emergency_relationship": moreInformation && isEmergencyInformation ? emergencyRelationship : null,
        if (moreInformation && badRecordId != null) "bad_record_id": badRecordId,
        "military_status": moreInformation ? militaryStatus?.value : null,
        "insurance_type": moreInformation ? insuranceType?.value : null,
        "education_type": moreInformation ? educationType?.name : null,
        "employment_type": moreInformation ? employmentType?.value : null,
        "salary_type": moreInformation ? salaryType?.value : null,
        "favorite_name_list": moreInformation ? favorites : null,
        "skill_name_list": moreInformation ? skills : null,
      };
}
