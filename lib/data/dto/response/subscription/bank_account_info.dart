part of '../../../data.dart';

class BankAccountInfoReadDto {
  const BankAccountInfoReadDto({
    required this.bankName,
    required this.iban,
    required this.accountOwnerName,
  });

  final String bankName;
  final String iban;
  final String accountOwnerName;

  factory BankAccountInfoReadDto.fromJson(final String str) => BankAccountInfoReadDto.fromMap(json.decode(str));

  factory BankAccountInfoReadDto.fromMap(final Map<String, dynamic> json) => BankAccountInfoReadDto(
        bankName: json["bank_name"] ?? '',
        iban: json["shaba_number"] ?? '',
        accountOwnerName: json["bank_account_owner_name"] ?? '',
      );
}
