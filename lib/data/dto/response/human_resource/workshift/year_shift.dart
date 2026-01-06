part of '../../../../data.dart';

class YearShiftReadDto extends Equatable {
  final int? id;
  final String slug;
  final int year;
  final String? workshiftSlug;
  final List <dynamic>? customData;
  final List<MonthShiftReadDto>? months;

  const YearShiftReadDto({
    this.id,
    required this.slug,
    required this.year,
    this.workshiftSlug,
    this.customData,
    this.months,
  });

  factory YearShiftReadDto.fromMap(final Map<String, dynamic> json) {
    return YearShiftReadDto(
      id: json["id"],
      slug: json["slug"] ?? '',
      year: json["year"] ?? 0,
      workshiftSlug: json["workshift_slug"],
      customData: json["custom_data"] as List?,
      months: json["months"] == null
          ? null
          : List<MonthShiftReadDto>.from(json["months"]!.map((final x) => MonthShiftReadDto.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [id, slug, year, workshiftSlug, customData, months];
}

