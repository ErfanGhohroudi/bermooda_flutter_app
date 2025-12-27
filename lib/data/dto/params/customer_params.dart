part of '../../data.dart';

class CustomerParams {
  CustomerParams({
    this.crmCategoryId,
    this.sectionId,
    this.avatarId,
    this.personalType,
    this.gender,
    this.industry,
    this.industrySubCategory,
    this.labels,
    this.fullNameOrCompanyName,
    this.amount,
    // this.currency,
    this.salesProbability,
    this.connectionType,
    this.phoneNumber,
    this.email,
    this.socialMediaLink,
    this.website,
    this.landline,
    this.extension,
    this.state,
    this.city,
    this.address,
    this.fax,
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

  String? crmCategoryId;
  int? sectionId;
  int? avatarId;
  AuthenticationType? personalType;
  GenderType? gender;
  DropdownItemReadDto? industry;
  DropdownItemReadDto? industrySubCategory;
  List<LabelReadDto>? labels;
  String? fullNameOrCompanyName;
  String? amount;

  // CurrencyUnitReadDto? currency;
  int? salesProbability;
  ConnectionType? connectionType;
  String? phoneNumber;
  String? email;
  String? socialMediaLink;
  String? website;
  String? landline;
  String? extension;
  DropdownItemReadDto? state;
  DropdownItemReadDto? city;
  String? address;
  String? fax;
  String? companyNationalCode;
  String? nationalCode;
  String? economicCode;
  String? shebaNumber;
  String? certificateNumber;
  String? postalCode;
  String? birthday;
  String? agentName;
  String? agentPhoneNumber;
  String? agentLandline;
  String? agentLandlineExt;
  String? agentPosition;
  String? agentLink;
  String? agentEmail;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "group_crm_id": crmCategoryId,
        "label_id": sectionId,
        if (avatarId != null) "avatar_id": avatarId,
        "normalized_personal_type": personalType?.name,
        if (personalType == AuthenticationType.person) "gender": gender?.name,
        "industrial_activity_id": industry?.id,
        "industrial_sub_category_id": industrySubCategory?.id,
        if (labels != null) "category_id_list": labels?.map((final e) => e.id).toList(),
        "fullname_or_company_name": fullNameOrCompanyName,
        "sell_balance": amount,
        // if (!amount.isNullOrEmpty() && currency != null) "currency_slug": currency?.slug,
        "possibility_of_sale": salesProbability ?? 0,
        if (connectionType != null) "conection_type": connectionType?.name,
        "phone_number": phoneNumber,
        "email": email,
        "social_media_link": socialMediaLink,
        "link": website,
        "phone_number_static": landline,
        "extension_number": extension,
        if (state?.id != null) "state_id": state?.id,
        if (city?.id != null) "city_id": city?.id,
        "address": address,
        "fax": fax,
        "company_national_code": companyNationalCode,
        "national_code": nationalCode,
        "economic_code": economicCode,
        "shaba_number": shebaNumber,
        "certificate_number": certificateNumber,
        "postal_code": postalCode,
        "birthday_date_jalali": birthday,
        "agent_status": false,
        "agent_name": agentName,
        "agent_phone_number": agentPhoneNumber,
        "agent_phone_number_static": agentLandline,
        "agent_extension_phone_number": agentLandlineExt,
        "agent_position": agentPosition,
        "agent_email_or_link": agentLink,
        "agent_main_email": agentEmail,
      };

  // List<List<String>> getExelFields() => [
  List<DropdownItemReadDto> getExelFields() => [
        DropdownItemReadDto(slug: 'normalized_personal_type', title: s.type),
        DropdownItemReadDto(slug: 'gender', title: s.gender),
        DropdownItemReadDto(slug: 'fullname_or_company_name', title: '${s.customerName}/${s.companyName}'),
        DropdownItemReadDto(slug: 'phone_number', title: s.phoneNumber),
        DropdownItemReadDto(slug: 'email', title: s.email),
        DropdownItemReadDto(slug: 'social_media_link', title: s.socialMediaLink),
        DropdownItemReadDto(slug: 'link', title: s.link),
        DropdownItemReadDto(slug: 'phone_number_static', title: s.landline),
        DropdownItemReadDto(slug: 'extension_number', title: s.extension),
        DropdownItemReadDto(slug: 'state', title: s.state),
        DropdownItemReadDto(slug: 'city', title: s.city),
        DropdownItemReadDto(slug: 'address', title: s.address),
        DropdownItemReadDto(slug: 'fax', title: s.fax),
        DropdownItemReadDto(slug: 'company_national_code', title: s.companyNationalID),
        DropdownItemReadDto(slug: 'national_code', title: s.nationalID),
        DropdownItemReadDto(slug: 'economic_code', title: s.economicCode),
        DropdownItemReadDto(slug: 'certificate_number', title: s.birthCertificateNumber),
        DropdownItemReadDto(slug: 'postal_code', title: s.postalCode),
        DropdownItemReadDto(slug: 'birthday_date_jalali', title: s.dateOfBirth),
        DropdownItemReadDto(slug: 'agent_name', title: s.representativeName),
        DropdownItemReadDto(slug: 'agent_phone_number', title: '${s.phoneNumber} (${s.representative})'),
        DropdownItemReadDto(slug: 'agent_phone_number_static', title: '${s.landline} (${s.representative})'),
        DropdownItemReadDto(slug: 'agent_extension_phone_number', title: '${s.extension} (${s.representative})'),
        DropdownItemReadDto(slug: 'agent_position', title: '${s.role} (${s.representative})'),
        DropdownItemReadDto(slug: 'agent_email_or_link', title: '${s.link} (${s.representative})'),
        DropdownItemReadDto(slug: 'agent_main_email', title: '${s.email} (${s.representative})'),
        DropdownItemReadDto(slug: null, title: s.ignore),
      ];
}
