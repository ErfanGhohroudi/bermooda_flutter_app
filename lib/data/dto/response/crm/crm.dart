part of '../../../data.dart';

class CrmCategoryReadDto extends Equatable {
  const CrmCategoryReadDto({
    this.id,
    this.title,
    this.avatar,
    this.members,
    this.profitPrice,
    this.progress = 0,
  });

  final String? id;
  final String? title;
  final MainFileReadDto? avatar;
  final List<UserReadDto>? members;
  final String? profitPrice;
  final int progress;

  factory CrmCategoryReadDto.fromJson(final String str) => CrmCategoryReadDto.fromMap(json.decode(str));

  factory CrmCategoryReadDto.fromMap(final Map<String, dynamic> json) => CrmCategoryReadDto(
        id: json["id"]?.toString(),
        title: json["title"],
        avatar: json["avatar"] == null || json["avatar"] is! Map<String, dynamic> ? null : MainFileReadDto.fromMap(json["avatar"]),
        members: json["members"] == null ? [] : List<UserReadDto>.from(json["members"]!.map((final x) => UserReadDto.fromMap(x))),
        profitPrice: json["profit_price"],
        progress: json["group_crm_progress"]?.round() ?? 0,
      );

  @override
  List<Object?> get props => [id, title, avatar, members, profitPrice, progress];
}
