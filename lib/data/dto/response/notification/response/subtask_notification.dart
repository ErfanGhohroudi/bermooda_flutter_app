part of '../../../../data.dart';

class SubtaskNotificationReadDto extends INotificationReadDto {
  const SubtaskNotificationReadDto({
    super.id,
    super.title,
    super.subTitle,
    super.isRead,
    super.createdAt,
    this.subtask,
  });

  final SubtaskReadDto? subtask;

  factory SubtaskNotificationReadDto.fromJson(final String str) => SubtaskNotificationReadDto.fromMap(json.decode(str));

  factory SubtaskNotificationReadDto.fromMap(final Map<String, dynamic> json) {
    final DateTime? dateTime = DateTime.tryParse(json["created_at"].toString().trim());

    return SubtaskNotificationReadDto(
      id: json["id"],
      title: json["title"],
      subTitle: json["sub_title"],
      isRead: json["is_read"],
      createdAt: dateTime,
      subtask: json["related_object"]?["data"] == null ? null : SubtaskReadDto.fromMap(json["related_object"]["data"]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subTitle,
    isRead,
    createdAt,
    subtask,
  ];
}
