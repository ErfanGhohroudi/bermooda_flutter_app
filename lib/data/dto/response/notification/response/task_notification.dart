part of '../../../../data.dart';

class TaskNotificationReadDto extends INotificationReadDto {
  const TaskNotificationReadDto({
    super.id,
    super.title,
    super.subTitle,
    super.isRead,
    super.createdAt,
    this.task,
  });

  final TaskReadDto? task;

  factory TaskNotificationReadDto.fromJson(final String str) => TaskNotificationReadDto.fromMap(json.decode(str));

  factory TaskNotificationReadDto.fromMap(final Map<String, dynamic> json) {
    final DateTime? dateTime = DateTime.tryParse(json["created_at"].toString().trim());

    return TaskNotificationReadDto(
      id: json["id"],
      title: json["title"],
      subTitle: json["sub_title"],
      isRead: json["is_read"],
      createdAt: dateTime,
      task: json["related_object"]?["data"] == null ? null : TaskReadDto.fromMap(json["related_object"]["data"]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subTitle,
    isRead,
    createdAt,
    task,
  ];
}
