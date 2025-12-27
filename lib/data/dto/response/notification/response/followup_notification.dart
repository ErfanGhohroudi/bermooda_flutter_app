part of '../../../../data.dart';

class FollowupNotificationReadDto extends INotificationReadDto {
  const FollowupNotificationReadDto({
    super.id,
    super.title,
    super.subTitle,
    super.isRead,
    super.createdAt,
    this.followup,
  });

  final FollowUpReadDto? followup;

  factory FollowupNotificationReadDto.fromJson(final String str) => FollowupNotificationReadDto.fromMap(json.decode(str));

  factory FollowupNotificationReadDto.fromMap(final Map<String, dynamic> json) {
    final DateTime? dateTime = DateTime.tryParse(json["created_at"].toString().trim());

    return FollowupNotificationReadDto(
      id: json["id"],
      title: json["title"],
      subTitle: json["sub_title"],
      isRead: json["is_read"],
      createdAt: dateTime,
      followup: json["related_object"]?["data"] == null ? null : FollowUpReadDto.fromMap(json["related_object"]["data"]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subTitle,
    isRead,
    createdAt,
    followup,
  ];
}
