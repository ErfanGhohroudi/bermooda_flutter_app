part of '../../../data.dart';

class CustomerReadDto extends Equatable {
  const CustomerReadDto({
    this.id,
    this.followUpsOwners = const [],
    this.followUps = const [],
    this.amount,
    // this.currency,
    this.isDeleted = false,
    this.crmCategoryId,
    this.avatar,
    this.stepStatus,
    this.order,
    this.section,
    this.personalType,
    this.fullNameOrCompanyName,
    this.salesProbability,
    this.connectionType,
    this.phoneNumber,
    this.email,
    this.socialMediaLink,
    this.isFollowed = false,
    this.landline,
    this.extension,
    this.address,
    this.city,
    this.state,
    this.website,
    this.fax,
    this.gender,
    this.industrialActivity,
    this.industrySubcategory,
    this.labels = const [],
    this.companyNationalCode,
    this.nationalCode,
    this.economicCode,
    this.shebaNumber,
    this.certificateNumber,
    this.postalCode,
    this.birthday,
    this.agentName,
    this.agentPhoneNumber,
    this.agentLandline,
    this.agentLandlineExt,
    this.agentPosition,
    this.agentLink,
    this.agentEmail,
  });

  final int? id;
  final List<UserReadDto> followUpsOwners;
  final List<FollowUpReadDto> followUps;
  final String? amount;
  // final CurrencyUnitReadDto? currency;
  final bool isDeleted;
  final String? crmCategoryId;
  final MainFileReadDto? avatar;
  final int? stepStatus;
  final int? order;
  final CrmSectionReadDto? section;
  final AuthenticationType? personalType;
  final String? fullNameOrCompanyName;
  final int? salesProbability;
  final ConnectionType? connectionType;
  final String? phoneNumber;
  final String? email;
  final String? socialMediaLink;
  final bool isFollowed;
  final String? landline;
  final String? extension;
  final String? address;
  final DropdownItemReadDto? city;
  final DropdownItemReadDto? state;
  final String? website;
  final String? fax;
  final GenderType? gender;
  final DropdownItemReadDto? industrialActivity;
  final DropdownItemReadDto? industrySubcategory;
  final List<LabelReadDto> labels;
  final String? companyNationalCode;
  final String? nationalCode;
  final String? economicCode;
  final String? shebaNumber;
  final String? certificateNumber;
  final String? postalCode;
  final String? birthday;
  final String? agentName;
  final String? agentPhoneNumber;
  final String? agentLandline;
  final String? agentLandlineExt;
  final String? agentPosition;
  final String? agentLink;
  final String? agentEmail;

  CustomerReadDto copyWith({
    final int? id,
    final List<UserReadDto>? followUpsOwners,
    final List<FollowUpReadDto>? followUps,
    final String? amount,
    final CurrencyUnitReadDto? currency,
    final bool? isDeleted,
    final String? crmCategoryId,
    final MainFileReadDto? avatar,
    final int? stepStatus,
    final int? order,
    final CrmSectionReadDto? section,
    final AuthenticationType? personalType,
    final String? fullNameOrCompanyName,
    final int? salesProbability,
    final ConnectionType? connectionType,
    final String? phoneNumber,
    final String? email,
    final String? socialMediaLink,
    final DropdownItemReadDto? industrySubcategory,
    final List<LabelReadDto>? labels,
    final bool? isFollowed,
    final String? landline,
    final String? extension,
    final String? address,
    final DropdownItemReadDto? city,
    final DropdownItemReadDto? state,
    final String? website,
    final String? fax,
    final GenderType? gender,
    final DropdownItemReadDto? industrialActivity,
    final String? companyNationalCode,
    final String? nationalCode,
    final String? economicCode,
    final String? shebaNumber,
    final String? certificateNumber,
    final String? postalCode,
    final String? birthday,
    final String? agentName,
    final String? agentPhoneNumber,
    final String? agentLandline,
    final String? agentLandlineExt,
    final String? agentPosition,
    final String? agentLink,
    final String? agentEmail,
  }) {
    return CustomerReadDto(
      id: id ?? this.id,
      followUpsOwners: followUpsOwners ?? this.followUpsOwners,
      followUps: followUps ?? this.followUps,
      amount: amount ?? this.amount,
      // currency: currency ?? this.currency,
      isDeleted: isDeleted ?? this.isDeleted,
      crmCategoryId: crmCategoryId ?? this.crmCategoryId,
      avatar: avatar ?? this.avatar,
      stepStatus: stepStatus ?? this.stepStatus,
      order: order ?? this.order,
      section: section ?? this.section,
      personalType: personalType ?? this.personalType,
      fullNameOrCompanyName: fullNameOrCompanyName ?? this.fullNameOrCompanyName,
      salesProbability: salesProbability ?? this.salesProbability,
      connectionType: connectionType ?? this.connectionType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      socialMediaLink: socialMediaLink ?? this.socialMediaLink,
      industrySubcategory: industrySubcategory ?? this.industrySubcategory,
      labels: labels ?? this.labels,
      isFollowed: isFollowed ?? this.isFollowed,
      landline: landline ?? this.landline,
      extension: extension ?? this.extension,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      website: website ?? this.website,
      fax: fax ?? this.fax,
      gender: gender ?? this.gender,
      industrialActivity: industrialActivity ?? this.industrialActivity,
      companyNationalCode: companyNationalCode ?? this.companyNationalCode,
      nationalCode: nationalCode ?? this.nationalCode,
      economicCode: economicCode ?? this.economicCode,
      shebaNumber: shebaNumber ?? this.shebaNumber,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      postalCode: postalCode ?? this.postalCode,
      birthday: birthday ?? this.birthday,
      agentName: agentName ?? this.agentName,
      agentPhoneNumber: agentPhoneNumber ?? this.agentPhoneNumber,
      agentLandline: agentLandline ?? this.agentLandline,
      agentLandlineExt: agentLandlineExt ?? this.agentLandlineExt,
      agentPosition: agentPosition ?? this.agentPosition,
      agentLink: agentLink ?? this.agentLink,
      agentEmail: agentEmail ?? this.agentEmail,
    );
  }

  factory CustomerReadDto.fromJson(final String str) => CustomerReadDto.fromMap(json.decode(str));

  factory CustomerReadDto.fromMap(final Map<String, dynamic> json) => CustomerReadDto(
        id: json["id"],
        followUpsOwners: json["user_tracking"] == null ? [] : List<UserReadDto>.from(json["user_tracking"]!.map((final x) => UserReadDto.fromMap(x))),
        followUps: json["followup_list"] == null ? [] : List<FollowUpReadDto>.from(json["followup_list"]!.map((final x) => FollowUpReadDto.fromMap(x))),
        amount: json["sell_balance"]?.toString(),
        // currency: json["currency"] == null ? null : CurrencyUnitReadDto.fromMap(json["currency"]),
        isDeleted: json["is_deleted"] ?? false,
        crmCategoryId: json["group_crm_id_main"]?.toString(),
        avatar: json["avatar_url"] == null ? null : MainFileReadDto.fromMap(json["avatar_url"]),
        stepStatus: json["step_status"],
        order: json["order"],
        section: json["label"] == null ? null : CrmSectionReadDto.fromMap(json["label"]),
        personalType: json["normalized_personal_type"] == null ? null : AuthenticationType.values.firstWhereOrNull((final e) => e.name == json["normalized_personal_type"]),
        fullNameOrCompanyName: json["fullname_or_company_name"],
        salesProbability: json["possibility_of_sale"] == null ? null : (json["possibility_of_sale"]?.round() > 100 ? 100 : json["possibility_of_sale"]?.round()),
        connectionType: json["conection_type"] == null ? null : ConnectionType.values.firstWhereOrNull((final e) => e.name == json["conection_type"]),
        phoneNumber: json["phone_number"],
        email: json["email"],
        socialMediaLink: json["social_media_link"],
        industrySubcategory: json["industrial_sub_category"] == null ? null : DropdownItemReadDto.fromMap(json["industrial_sub_category"]),
        labels: json["category"] == null ? [] : List<LabelReadDto>.from(json["category"]!.map((final x) => LabelReadDto.fromMap(x))),
        isFollowed: json["is_followed"] ?? false,
        landline: json["phone_number_static"],
        extension: json["extension_number"],
        address: json["address"],
        city: json["city"] == null ? null : DropdownItemReadDto.fromMap(json["city"]),
        state: json["state"] == null ? null : DropdownItemReadDto.fromMap(json["state"]),
        website: json["link"],
        fax: json["fax"]?.toString(),
        gender: json["gender"] == null ? null : GenderType.values.firstWhereOrNull((final e) => e.name == json["gender"]),
        industrialActivity: json["industrial_activity"] == null ? null : DropdownItemReadDto.fromMap(json["industrial_activity"]),
        companyNationalCode: json["company_national_code"]?.toString(),
        nationalCode: json["national_code"]?.toString(),
        economicCode: json["economic_code"]?.toString(),
        shebaNumber: json["shaba_number"],
        certificateNumber: json["certificate_number"],
        postalCode: json["postal_code"],
        birthday: json["birthday_date_jalali"],
        agentName: json["agent_name"],
        agentPhoneNumber: json["agent_phone_number"],
        agentLandline: json["agent_phone_number_static"],
        agentLandlineExt: json["agent_extension_phone_number"],
        agentPosition: json["agent_position"],
        agentLink: json["agent_email_or_link"],
        agentEmail: json["agent_main_email"],
      );

  @override
  List<Object?> get props => [
    id,
    followUpsOwners,
    followUps,
    amount,
    // currency,
    isDeleted,
    crmCategoryId,
    avatar,
    stepStatus,
    order,
    section,
    personalType,
    fullNameOrCompanyName,
    salesProbability,
    connectionType,
    phoneNumber,
    email,
    socialMediaLink,
    isFollowed,
    landline,
    extension,
    address,
    city,
    state,
    website,
    fax,
    gender,
    industrialActivity,
    industrySubcategory,
    labels,
    companyNationalCode,
    nationalCode,
    economicCode,
    shebaNumber,
    certificateNumber,
    postalCode,
    birthday,
    agentName,
    agentPhoneNumber,
    agentLandline,
    agentLandlineExt,
    agentPosition,
    agentLink,
    agentEmail,
  ];
}
