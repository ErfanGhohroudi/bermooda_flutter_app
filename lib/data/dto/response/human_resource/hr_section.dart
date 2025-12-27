part of '../../../data.dart';

class HRSectionReadDto extends Equatable {
  const HRSectionReadDto({
    this.slug,
    this.title,
    this.icon,
    this.colorCode,
  });

  final String? slug;
  final String? title;
  final MainFileReadDto? icon;
  final String? colorCode;

  factory HRSectionReadDto.fromJson(final String str) => HRSectionReadDto.fromMap(json.decode(str));

  factory HRSectionReadDto.fromMap(final Map<String, dynamic> json) => HRSectionReadDto(
        slug: json["slug"],
        title: json["title"],
        icon: json["icon"] == null ? null : MainFileReadDto.fromMap(json["icon"]),
        colorCode: json["color_code"],
      );

  @override
  List<Object?> get props => [
        slug,
        title,
        colorCode,
      ];
}
