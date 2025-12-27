part of '../../../data.dart';

class HRDepartmentReadDto extends Equatable {
  HRDepartmentReadDto({
    this.id,
    this.title,
    this.avatar,
    this.slug,
    this.members = const [],
    this.progress = 0,
  });

  final int? id;
  final String? title;
  final MainFileReadDto? avatar;
  final String? slug;
  List<UserReadDto> members;
  final int progress;

  factory HRDepartmentReadDto.fromJson(final String str) => HRDepartmentReadDto.fromMap(json.decode(str));

  factory HRDepartmentReadDto.fromMap(final Map<String, dynamic> json) => HRDepartmentReadDto(
        id: json["id"],
        title: json["title"],
        avatar: json["avatar"] == null ? null : MainFileReadDto.fromMap(json["avatar"]),
        slug: json["slug"],
        members: json["members"] == null ? [] : List<UserReadDto>.from(json["members"].map((final x) => UserReadDto.fromMap(x))),
        progress: json["success_performance_rate"]?.round() ?? 0,
      );

  @override
  List<Object?> get props => [id, title, avatar, slug, members, progress];
}
