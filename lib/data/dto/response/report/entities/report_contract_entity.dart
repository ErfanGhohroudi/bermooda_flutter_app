part of '../../../../data.dart';

class ContractEntity extends Equatable {
  const ContractEntity({
    this.slug,
    this.title,
    this.contractType,
    this.startDate,
    this.endDate,
    this.amount,
    // this.currency,
    this.files = const [],
  });

  final String? slug;
  final String? title;
  final LabelReadDto? contractType;
  final Jalali? startDate;
  final Jalali? endDate;
  final String? amount;
  // final CurrencyUnitReadDto? currency;
  final List<MainFileReadDto> files;

  factory ContractEntity.fromJson(final String str) => ContractEntity.fromMap(json.decode(str));

  factory ContractEntity.fromMap(final Map<String, dynamic> json) => ContractEntity(
    slug: json["slug"],
    title: json["title"],
    contractType: json["contract_type"] == null ? null : LabelReadDto.fromMap(json["contract_type"]),
    startDate: json["start_date"] == null ? null : DateTime.tryParse(json["start_date"])?.toJalali(),
    endDate: json["end_date"] == null ? null : DateTime.tryParse(json["end_date"])?.toJalali(),
    amount: json["amount"]?.toString(),
    // currency: json["currency"] == null ? null : CurrencyUnitReadDto.fromMap(json["currency"]),
    files: json["attached_file"] == null ? [] : List<MainFileReadDto>.from(json["attached_file"].map((final x) => MainFileReadDto.fromMap(x))),
  );

  @override
  List<Object?> get props => [
    slug,
    title,
    contractType?.slug,
    startDate?.formatCompactDate(),
    endDate?.formatCompactDate(),
    amount,
    // currency,
    files,
  ];
}