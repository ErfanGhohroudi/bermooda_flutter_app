part of '../../../data.dart';

class StatusReasonReadDto {
  StatusReasonReadDto({
    this.slug,
    this.title,
    this.colorCode,
    this.type,
  });

  String? slug;
  String? title;
  String? colorCode;
  CustomerStatus? type;

  factory StatusReasonReadDto.fromJson(final String str) => StatusReasonReadDto.fromMap(json.decode(str));

  factory StatusReasonReadDto.fromMap(final Map<String, dynamic> json) => StatusReasonReadDto(
        slug: json["slug"],
        title: json["title"],
        colorCode: json["color_code"],
        type: json["category_type"] == null ? null : CustomerStatus.values.firstWhereOrNull((final type) => type.name == json["category_type"]),
      );
}