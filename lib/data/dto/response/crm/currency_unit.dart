part of '../../../data.dart';

class CurrencyUnitReadDto extends Equatable {
  final String? slug;
  final String? currencyName;
  final String? country;

  const CurrencyUnitReadDto({
    this.slug,
    this.currencyName,
    this.country,
  });

  factory CurrencyUnitReadDto.fromJson(final String str) => CurrencyUnitReadDto.fromMap(json.decode(str));

  factory CurrencyUnitReadDto.fromMap(final Map<String, dynamic> json) => CurrencyUnitReadDto(
        slug: json["slug"],
        currencyName: json["currency_name"],
        country: json["country_name"],
      );

  @override
  List<Object?> get props => [slug, currencyName, country];
}
