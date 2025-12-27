part of '../../data.dart';

class NoticeReadDto extends Equatable {
  const NoticeReadDto({
    this.slug,
    this.createAt,
    this.title,
    this.description,
    this.notifDate,
  });

  final String? slug;
  final String? createAt;
  final String? title;
  final String? description;
  final String? notifDate;

  factory NoticeReadDto.fromJson(final String str) => NoticeReadDto.fromMap(json.decode(str));

  factory NoticeReadDto.fromMap(final dynamic json) => NoticeReadDto(
        slug: json["slug"],
        createAt: json["created_at_jalali"],
        title: json["title"],
        description: json["description"],
        notifDate: json["notif_date_jalali"],
      );

  @override
  List<Object?> get props => [slug, title, description, notifDate];
}
