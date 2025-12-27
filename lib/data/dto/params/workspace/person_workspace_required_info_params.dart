part of '../../../data.dart';

class PersonWorkspaceRequiredInfoParams extends BaseWorkspaceRequiredInfoParams {
  PersonWorkspaceRequiredInfoParams({
    required super.authenticationType,
    required this.fullName,
    required this.nationalId,
    required this.phoneNumber,
    this.email,
  });

  final String fullName;
  final String nationalId;
  final String phoneNumber;
  final String? email;

  @override
  AuthenticationType get authenticationType => AuthenticationType.person;

  @override
  String toJson() => json.encode(removeNullEntries(toMap())).englishNumber();

  @override
  Map<String, dynamic> toMap() => <String, dynamic> {
    ...super.toMap(),
    "fullname": fullName,
    "national_code": nationalId, // کد ملی
    "phone_number": phoneNumber,
    "email": email,
  };
}