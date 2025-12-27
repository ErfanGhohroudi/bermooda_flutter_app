part of '../../data.dart';

class LabelReadDto {
  LabelReadDto({
    this.id,
    this.slug,
    this.title,
    this.colorCode,
    this.eventType,
  });

  int? id;
  String? slug;
  String? title;
  String? colorCode;
  /// Meeting
  EventType? eventType; //meeting label

  factory LabelReadDto.fromJson(final String str) => LabelReadDto.fromMap(json.decode(str));

  factory LabelReadDto.fromMap(final Map<String, dynamic> json) => LabelReadDto(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        colorCode: json["color_code"] ?? json["color"],
        eventType: json["key_name"] == null ? null : EventType.values.firstWhereOrNull((final type) => type.name == json["key_name"]),
      );
}