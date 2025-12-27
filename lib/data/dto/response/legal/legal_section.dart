part of '../../../data.dart';

class LegalSectionReadDto extends Equatable {
  const LegalSectionReadDto({
    this.id,
    this.title,
    this.colorCode,
    this.isDefault = false,
    this.columnSlug,
    this.icon,
  });

  final int? id;
  final String? title;
  final String? colorCode;
  final bool isDefault;
  final String? columnSlug;
  final MainFileReadDto? icon;

  factory LegalSectionReadDto.fromJson(final String str) => LegalSectionReadDto.fromMap(json.decode(str));

  factory LegalSectionReadDto.fromMap(final Map<String, dynamic> json) => LegalSectionReadDto(
        id: json['id'] as int?,
        title: json["title"],
        colorCode: json["color_code"],
        isDefault: json['is_default'] as bool? ?? false,
        columnSlug: json['column_slug'] as String?,
        icon: json["icon"] == null ? null : MainFileReadDto.fromMap(json["icon"]),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        colorCode,
        isDefault,
        columnSlug,
        icon,
      ];
}
