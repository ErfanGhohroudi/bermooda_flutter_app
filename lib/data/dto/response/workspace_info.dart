part of '../../data.dart';

class WorkspaceInfoReadDto extends Equatable {
  const WorkspaceInfoReadDto({
    required this.id,
    this.title,
    this.industrialActivity,
    this.personalInformationStatus = false,
    this.name,
    // this.jadooBrandName,
    this.city,
    this.state,
    this.stateName,
    this.cityName,
    this.businessEmployer,
    this.personType,
    this.nationalCode,
    this.email,
    this.postalCode,
    this.shebaNumber,
    this.phoneNumber,
    this.telNumber,
    this.faxNumber,
    this.registrationNumber,
    this.economicNumber,
    this.address,
    this.avatar,
    this.permissions,
    this.subscription,
  });

  final String id;
  final String? title;
  final DropdownItemReadDto? industrialActivity;
  final bool personalInformationStatus;
  final String? name; // from company_name to name
  // final String? jadooBrandName;
  final int? city;
  final int? state;
  final String? stateName;
  final String? cityName;
  final BusinessSize? businessEmployer;
  final AuthenticationType? personType;
  final String? nationalCode;
  final String? email;
  final String? postalCode;
  final String? shebaNumber;
  final String? phoneNumber;
  final String? telNumber;
  final String? faxNumber;
  final String? registrationNumber;
  final String? economicNumber;
  final String? address;
  final MainFileReadDto? avatar;
  final List<PermissionReadDto>? permissions;
  final SubscriptionReadDto? subscription;

  factory WorkspaceInfoReadDto.fromJson(final String str) => WorkspaceInfoReadDto.fromMap(json.decode(str));

  factory WorkspaceInfoReadDto.fromMap(final Map<String, dynamic> json) {
    final personType = AuthenticationType.values.firstWhereOrNull((final element) => element.name == json["person_type"]);
    return WorkspaceInfoReadDto(
      id: json["id"].toString(),
      title: json["title"],
      industrialActivity: json["industrialactivity"] == null ? null : DropdownItemReadDto.fromMap(json["industrialactivity"]),
      personalInformationStatus: json["personal_information_status"] ?? false,
      personType: personType,
      name: personType == AuthenticationType.legal
          ? json["company_name"]
          : personType == AuthenticationType.person
          ? json["fullname"]
          : json["fullname"] ?? json["company_name"],
      // jadooBrandName: json["jadoo_brand_name"],
      city: json["city"],
      state: json["state"],
      stateName: json["state_name"],
      cityName: json["city_name"],
      businessEmployer: BusinessSize.values.firstWhereOrNull((final e) => e.titleTr1 == json["business_employer"]),
      nationalCode: json["national_code"],
      email: json["email"],
      postalCode: json["postal_code"],
      shebaNumber: json["shaba_number"],
      phoneNumber: json["phone_number"],
      telNumber: json["tel_number"],
      faxNumber: json["fax_number"],
      registrationNumber: json["registration_number"],
      economicNumber: json["economic_number"],
      address: json["address"],
      avatar: json["avatar"] == null ? null : MainFileReadDto.fromMap(json["avatar"]),
      permissions: json["permissions"] == null
          ? []
          : List<PermissionReadDto>.from(json["permissions"]!.map((final x) => PermissionReadDto.fromMap(x))),
      subscription: json["main_subscription"] == null ? null : SubscriptionReadDto.fromMap(json["main_subscription"]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    industrialActivity,
    personalInformationStatus,
    name,
    // jadooBrandName,
    city,
    state,
    stateName,
    cityName,
    businessEmployer,
    personType,
    nationalCode,
    email,
    postalCode,
    shebaNumber,
    phoneNumber,
    telNumber,
    faxNumber,
    registrationNumber,
    economicNumber,
    address,
    avatar,
    permissions,
    subscription,
  ];
}
