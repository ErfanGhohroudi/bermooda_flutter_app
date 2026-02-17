part of '../../../data.dart';

class InvoiceBuyerSellerInfo {
  BuyerInfo buyerInfo;
  SellerInfo sellerInfo;

  InvoiceBuyerSellerInfo({
    required this.buyerInfo,
    required this.sellerInfo,
  });

  factory InvoiceBuyerSellerInfo.fromMap(final Map<String, dynamic> json) => InvoiceBuyerSellerInfo(
    buyerInfo: BuyerInfo.fromMap(json["customer_data"] ?? {}),
    sellerInfo: SellerInfo.fromMap(json["workspace_data"] ?? {}),
  );
}

class BuyerInfo {
  String name;
  String phoneNumber;
  String? nationalCode;
  String? economicCode;
  DropdownItemReadDto? state;
  DropdownItemReadDto? city;
  String address;

  BuyerInfo({
    required this.name,
    required this.phoneNumber,
    this.nationalCode,
    this.economicCode,
    this.state,
    this.city,
    required this.address,
  });

  factory BuyerInfo.fromMap(final Map<String, dynamic> json) => BuyerInfo(
    name: json['fullname_or_company_name'] ?? '',
    phoneNumber: json['phone_number']?.toString() ?? '',
    nationalCode: json['national_code']?.toString(),
    economicCode: json['economic_code']?.toString(),
    state: json['state'] == null ? null : DropdownItemReadDto.fromMap(json["state"]),
    city: json['city'] == null ? null : DropdownItemReadDto.fromMap(json["city"]),
    address: json['address'] ?? '',
  );
}

class SellerInfo {
  String name;
  AuthenticationType normalizedPersonalType;
  String? registrationNumber;
  bool personalInformationStatus;
  String? nationalCode;
  String? email;
  String? shebaNumber;
  String? postalCode;
  String phoneNumber;
  String? faxNumber;
  String? economicNumber;
  DropdownItemReadDto? state;
  DropdownItemReadDto? city;
  String address;

  SellerInfo({
    required this.name,
    required this.normalizedPersonalType,
    this.registrationNumber,
    this.personalInformationStatus = false,
    this.nationalCode,
    this.email,
    this.shebaNumber,
    this.postalCode,
    required this.phoneNumber,
    this.faxNumber,
    this.economicNumber,
    this.state,
    this.city,
    required this.address,
  });

  factory SellerInfo.fromMap(final Map<String, dynamic> json) => SellerInfo(
    name: json['fullname'] ?? '',
    normalizedPersonalType:
        AuthenticationType.values.firstWhereOrNull((final type) => type.name == json["normalized_personal_type"]) ??
        AuthenticationType.person,
    registrationNumber: json['registration_number']?.toString(),
    personalInformationStatus: json['personal_information_status'] ?? false,
    nationalCode: json['national_code']?.toString(),
    email: json['email'],
    shebaNumber: json['shaba_number'],
    postalCode: json['postal_code']?.toString(),
    phoneNumber: json['phone_number']?.toString() ?? '',
    faxNumber: json['fax_number']?.toString(),
    economicNumber: json['economic_number']?.toString(),
    state: json['state'] == null ? null : DropdownItemReadDto.fromMap(json["state"]),
    city: json['city'] == null ? null : DropdownItemReadDto.fromMap(json["city"]),
    address: json['address'] ?? '',
  );
}
