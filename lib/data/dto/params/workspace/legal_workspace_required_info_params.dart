part of '../../../data.dart';

class LegalWorkspaceRequiredInfoParams extends BaseWorkspaceRequiredInfoParams {
  LegalWorkspaceRequiredInfoParams({
    required super.authenticationType,
    required this.organizationName,
    required this.economicCode,
    required this.nationalId,
    required this.registrationNumber,
    required this.landline,
    this.email,
  });

  final String organizationName;
  final String economicCode;
  final String nationalId;
  final String registrationNumber;
  final String landline;
  final String? email;

  @override
  AuthenticationType get authenticationType => AuthenticationType.legal;

  @override
  String toJson() => json.encode(removeNullEntries(toMap())).englishNumber();

  @override
  Map<String, dynamic> toMap() => <String, dynamic> {
    ...super.toMap(),
    "company_name": organizationName,
    "economic_number": economicCode, // کد اقتصادی
    "national_code": nationalId, // شناسه ملی
    "registration_number": registrationNumber, // شماره ثبت شرکت
    "tel_number": landline,
    "email": email,
  };
}