part of '../../../data.dart';

class ProjectSectionReadDto extends Equatable {
  const ProjectSectionReadDto({
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

  factory ProjectSectionReadDto.fromJson(final String str) => ProjectSectionReadDto.fromMap(json.decode(str));

  factory ProjectSectionReadDto.fromMap(final Map<String, dynamic> json) => ProjectSectionReadDto(
        id: json["id"] ?? json["category_id"],
        title: json["title"],
        colorCode: json["color"] ?? json["color_code"],
        icon: json["icon"] == null ? null : MainFileReadDto.fromMap(json["icon"]),
        order: json["order"],
      );

  @override
  List<Object?> get props => [id];
}
