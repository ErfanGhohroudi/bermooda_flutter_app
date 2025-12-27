part of '../../../../data.dart';

class CustomerNotificationReadDto extends INotificationReadDto {
  const CustomerNotificationReadDto({
    super.id,
    super.title,
    super.subTitle,
    super.isRead,
    super.createdAt,
    this.customer,
  });

  final CustomerReadDto? customer;

  factory CustomerNotificationReadDto.fromJson(final String str) => CustomerNotificationReadDto.fromMap(json.decode(str));

  factory CustomerNotificationReadDto.fromMap(final Map<String, dynamic> json) {
    final DateTime? dateTime = DateTime.tryParse(json["created_at"].toString().trim());

    return CustomerNotificationReadDto(
      id: json["id"],
      title: json["title"],
      subTitle: json["sub_title"],
      isRead: json["is_read"],
      createdAt: dateTime,
      customer: json["related_object"]?["data"] == null ? null : CustomerReadDto.fromMap(json["related_object"]["data"]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subTitle,
    isRead,
    createdAt,
    customer,
  ];
}
