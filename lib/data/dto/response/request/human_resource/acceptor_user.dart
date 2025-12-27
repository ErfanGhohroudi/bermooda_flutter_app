part of '../../../../data.dart';

class AcceptorUserReadDto {
  AcceptorUserReadDto({
    required this.slug,
    required this.user,
    this.status,
    this.isChecked = false,
    this.reviewDeadlineDate,
  });

  final String slug;
  final UserReadDto user;
  final StatusType? status;
  final bool isChecked;
  final DateTime? reviewDeadlineDate;

  factory AcceptorUserReadDto.fromJson(final String str) => AcceptorUserReadDto.fromMap(json.decode(str));

  factory AcceptorUserReadDto.fromMap(final Map<String, dynamic> json) => AcceptorUserReadDto(
    slug: json["slug"].toString(),
    user: json["accepter_user"] == null ? const UserReadDto(id: '') : UserReadDto.fromMap(json["accepter_user"]),
    status: json["accepted_status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["accepted_status"]),
    isChecked: json["is_checked"] ?? false,
    reviewDeadlineDate: json["review_date"] == null ? null : DateTime.tryParse(json["review_date"]),
  );
}