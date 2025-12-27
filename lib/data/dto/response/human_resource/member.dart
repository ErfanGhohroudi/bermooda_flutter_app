part of '../../../data.dart';

class MemberReadDto extends Equatable {
  final int? id;
  final HRDepartmentReadDto? department;
  final UserAccount? userAccount;
  final String? firstName;
  final String? lastName;
  final bool isAccepted;
  final String? jtime;
  final List<PermissionReadDto>? permissions;
  final String? workShiftSlug;
  final WorkShiftReadDto? workShift;
  final DropdownItemReadDto? state;
  final DropdownItemReadDto? city;
  final InsuranceType? insuranceType;
  final bool moreInformation;
  final bool isEmergencyInformation;
  final String? emergencyFirstName;
  final String? emergencyLastName;
  final String? emergencyPhoneNumber;
  final String? emergencyRelationship;
  final String? email;
  final String? dateOfBirthPersian;
  final String? nationalCode;
  final String? certificateNumber;
  final GenderType? gender;
  final String? address;
  final String? postalCode;
  final bool marriage;
  final int? numberOfChildren;
  final String? shabaNumber;
  final EducationType? educationType;
  final String? dateOfStartToWorkPersian;
  final String? contractEndDatePersian;
  final MainFileReadDto? badRecord;
  final String? jobPosition;
  final DropdownItemReadDto? studyCategory;
  final MilitaryStatus? militaryStatus;
  final OwnerMemberType? type;
  final List<String>? favorites;
  final List<String>? skills;
  final EmploymentType? employmentType;
  final SalaryType? salaryType;
  final String? personnelCode;

  String? get fullName {
    final memberFirstName = firstName?.trim() ?? '';
    final memberLastName = lastName?.trim() ?? '';
    final memberFullName = "$memberFirstName $memberLastName".trim();
    if (memberFullName.isEmpty) return null;
    return memberFullName;
  }

  const MemberReadDto({
    this.id,
    this.department,
    this.userAccount,
    this.firstName,
    this.lastName,
    this.isAccepted = false,
    this.jtime,
    this.permissions,
    this.workShiftSlug,
    this.workShift,
    this.state,
    this.city,
    this.insuranceType,
    this.moreInformation = false,
    this.isEmergencyInformation = false,
    this.emergencyFirstName,
    this.emergencyLastName,
    this.emergencyPhoneNumber,
    this.emergencyRelationship,
    this.email,
    this.dateOfBirthPersian,
    this.nationalCode,
    this.certificateNumber,
    this.gender,
    this.address,
    this.postalCode,
    this.marriage = false,
    this.numberOfChildren,
    this.shabaNumber,
    this.educationType,
    this.dateOfStartToWorkPersian,
    this.contractEndDatePersian,
    this.badRecord,
    this.jobPosition,
    this.studyCategory,
    this.militaryStatus,
    this.type,
    this.favorites,
    this.skills,
    this.employmentType,
    this.salaryType,
    this.personnelCode,
  });

  factory MemberReadDto.fromJson(final String str) => MemberReadDto.fromMap(json.decode(str));

  factory MemberReadDto.fromMap(final dynamic json) =>
      MemberReadDto(
        id: json["id"],
        department: json["folder_data"] == null ? null : HRDepartmentReadDto.fromMap(json["folder_data"]),
        userAccount: json["user_account"] == null ? null : UserAccount.fromMap(json["user_account"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        isAccepted: json["is_accepted"] ?? false,
        jtime: json["jtime"],
        permissions: json["permission_list"] == null
            ? []
            : List<PermissionReadDto>.from(json["permission_list"]!.map((final x) => PermissionReadDto.fromMap(x))),
        workShiftSlug: json["workshift_slug"],
        workShift: json["workshift"] == null ? null : WorkShiftReadDto.fromMap(json["workshift"]),
        state: json["state"] == null ? null : DropdownItemReadDto.fromMap(json["state"]),
        city: json["city"] == null ? null : DropdownItemReadDto.fromMap(json["city"]),
        insuranceType: json["insurance_type"] == null ? null : InsuranceType.values.firstWhereOrNull((final e) => e.name == json["insurance_type"]),
        moreInformation: json["more_information"] ?? false,
        isEmergencyInformation: json["is_emergency_information"] ?? false,
        emergencyFirstName: json["emergency_first_name"],
        emergencyLastName: json["emergency_last_name"],
        emergencyPhoneNumber: json["emergency_phone_number"],
        emergencyRelationship: json["emergency_relationship"],
        email: json["email"],
        dateOfBirthPersian: json["date_of_birth_persian"],
        nationalCode: json["national_code"],
        certificateNumber: json["certificate_number"],
        gender: json["gender"] == null ? null : GenderType.values.firstWhereOrNull((final e) => e.name == json["gender"]),
        address: json["address"],
        postalCode: json["postal_code"],
        marriage: json["marriage"] ?? false,
        numberOfChildren: json["number_of_children"],
        shabaNumber: json["shaba_number"],
        educationType: json["education_type"] == null ? null : EducationType.values.firstWhereOrNull((final e) => e.name == json["education_type"]),
        dateOfStartToWorkPersian: json["date_of_start_to_work_persian"],
        contractEndDatePersian: json["contract_end_date_persian"],
        badRecord: json["bad_record"] == null ? null : MainFileReadDto.fromMap(json["bad_record"]),
        jobPosition: json["job_position"],
        studyCategory: json["study_category"] == null ? null : DropdownItemReadDto.fromMap(json["study_category"]),
        militaryStatus: json["military_status"] == null ? null : MilitaryStatus.values.firstWhereOrNull((final e) => e.name == json["military_status"]),
        type: json["type"] != null || json["user_type"] != null ? OwnerMemberType.fromString(json["type"] ?? json["user_type"]) : null,
        favorites: json["favorite_name_list"] ?? [],
        skills: json["skill_name_list"] ?? [],
        employmentType: json["employment_type"] == null ? null : EmploymentType.values.firstWhereOrNull((final e) => e.value == json["employment_type"]),
        salaryType: json["salary_type"] == null ? null : SalaryType.values.firstWhereOrNull((final e) => e.value == json["salary_type"]),
        personnelCode: json["personal_code"],
      );

  @override
  List<Object?> get props =>
      [
        id,
        department,
        userAccount,
        firstName,
        lastName,
        isAccepted,
        jtime,
        permissions,
        workShiftSlug,
        workShift,
        state,
        city,
        insuranceType,
        moreInformation,
        isEmergencyInformation,
        emergencyFirstName,
        emergencyLastName,
        emergencyPhoneNumber,
        emergencyRelationship,
        email,
        dateOfBirthPersian,
        nationalCode,
        certificateNumber,
        gender,
        address,
        postalCode,
        marriage,
        numberOfChildren,
        shabaNumber,
        educationType,
        dateOfStartToWorkPersian,
        contractEndDatePersian,
        badRecord,
        jobPosition,
        studyCategory,
        militaryStatus,
        type,
        favorites,
        skills,
        employmentType,
        salaryType,
        personnelCode,
      ];
}

class UserAccount extends Equatable {
  final int? id;
  final String? phoneNumber;
  final String? fullName;
  final MainFileReadDto? avatarUrlMain;
  final bool? isRegister;

  const UserAccount({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.avatarUrlMain,
    this.isRegister,
  });

  factory UserAccount.fromJson(final String str) => UserAccount.fromMap(json.decode(str));

  factory UserAccount.fromMap(final dynamic json) =>
      UserAccount(
        id: json["id"],
        phoneNumber: json["phone_number"],
        fullName: json["fullname"],
        avatarUrlMain: json["avatar_url_main"] == null ? null : MainFileReadDto.fromMap(json["avatar_url_main"]),
        isRegister: json["is_register"],
      );

  @override
  List<Object?> get props =>
      [
        id,
        phoneNumber,
        fullName,
        avatarUrlMain,
        isRegister,
      ];
}

class PermissionReadDto extends Equatable {
  const PermissionReadDto({
    this.permissionName,
    this.permissionType,
  });

  final PermissionName? permissionName;
  final PermissionType? permissionType;

  PermissionReadDto copyWith({
    final PermissionName? permissionName,
    final PermissionType? permissionType,
  }) {
    return PermissionReadDto(
      permissionName: permissionName ?? this.permissionName,
      permissionType: permissionType ?? this.permissionType,
    );
  }

  factory PermissionReadDto.fromJson(final String str) => PermissionReadDto.fromMap(json.decode(str));

  factory PermissionReadDto.fromMap(final Map<String, dynamic> json) =>
      PermissionReadDto(
        permissionName: json["permission_name"] == null ? null : PermissionName.fromString(json["permission_name"]),
        permissionType: json["permission_type"] == null ? null : PermissionType.fromString(json["permission_type"]),
      );

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        "permission_name": permissionName?.value,
        "permission_type": permissionType?.value,
      };

  @override
  List<Object?> get props =>
      [
        permissionName,
        permissionType,
      ];
}
