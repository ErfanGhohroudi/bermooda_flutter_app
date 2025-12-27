part of '../../../data.dart';

class WorkspaceInfoParams {
  WorkspaceInfoParams({
    this.avatarId,
    this.title,
    this.jadooBrandName,
    this.industryId,
    this.businessSize,
    this.stateId,
    this.cityId,
    this.authenticationType,
    this.companyName,
    this.nationalCode,
    this.economicNumber,
    this.bankNumber,
    this.postalCode,
    this.telNumber,
    this.phoneNumber,
    this.faxNumber,
    this.email,
    this.address,
    this.nationalCardImageId,
    this.documentImageId,
  });

  final int? avatarId;
  final String? title;
  final String? jadooBrandName;
  final int? industryId;
  final BusinessSize? businessSize;
  final int? stateId;
  final int? cityId;
  final AuthenticationType? authenticationType;
  final String? companyName;
  final String? nationalCode;
  final String? economicNumber;
  final String? bankNumber;
  final String? postalCode;
  final String? telNumber;
  final String? phoneNumber;
  final String? faxNumber;
  final String? email;
  final String? address;
  final int? nationalCardImageId;
  final int? documentImageId;

  String toJson() => json.encode(removeNullEntries(toMap())).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "avatar_id": avatarId,
        "title": title,
        "jadoo_brand_name": jadooBrandName,
        "industrialactivity_id": industryId,
        "business_employer": businessSize?.titleTr1,
        "state": stateId,
        "city": cityId,
        "person_type": authenticationType?.name,
        "company_name": companyName,
        "national_code": nationalCode,
        "economic_number": economicNumber,
        "bank_number": bankNumber,
        "postal_code": postalCode,
        "tel_number": telNumber,
        "phone_number": phoneNumber,
        "fax_number": faxNumber,
        "email": email,
        "address": address,
        "national_card_image_id": nationalCardImageId,
        "document_image_id": documentImageId,
      };
}
