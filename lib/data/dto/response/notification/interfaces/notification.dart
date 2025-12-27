part of '../../../../data.dart';

class INotificationReadDto extends Equatable {
  const INotificationReadDto({
    this.id,
    this.title,
    this.subTitle,
    this.isRead = true,
    this.createdAt,
  });

  final int? id;
  final String? title;
  final String? subTitle;
  final bool isRead;
  final DateTime? createdAt;

  factory INotificationReadDto.fromJson(final String str) => INotificationReadDto.fromMap(json.decode(str));

  factory INotificationReadDto.fromMap(final Map<String, dynamic> json) {
    final dataTypeString = json["related_object"]?["data_type"] as String?;
    final dataType = dataTypeString == null
        ? null
        : NotificationDataType.values.firstWhereOrNull((final e) => e.name == dataTypeString);

    switch (dataType) {
      case NotificationDataType.task_data:
        return TaskNotificationReadDto.fromMap(json);
      case NotificationDataType.check_list_data:
        return SubtaskNotificationReadDto.fromMap(json);
      case NotificationDataType.customer_data:
        return CustomerNotificationReadDto.fromMap(json);
      case NotificationDataType.tracking_data:
        return FollowupNotificationReadDto.fromMap(json);
      default:
        return const INotificationReadDto();
    }
  }

  @override
  List<Object?> get props => [];
}
