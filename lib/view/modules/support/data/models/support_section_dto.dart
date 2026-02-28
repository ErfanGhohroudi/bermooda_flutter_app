import '../../../../../data/data.dart';

class SupportSectionReadDto {
  const SupportSectionReadDto({
    this.id,
    this.title,
    this.colorCode,
    this.icon,
    this.order,
  });

  final int? id;
  final String? title;
  final String? colorCode;
  final MainFileReadDto? icon;
  final String? order;

  factory SupportSectionReadDto.fromMap(final Map<String, dynamic> json) => SupportSectionReadDto(
    id: json["id"],
    title: json["title"],
    colorCode: json["color_code"],
    icon: json["icon"] == null ? null : MainFileReadDto.fromMap(json["icon"]),
    order: json["order"]?.toString(),
  );
}
