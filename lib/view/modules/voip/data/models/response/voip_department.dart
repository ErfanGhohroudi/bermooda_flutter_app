import 'package:bermooda_business/data/data.dart';

class VoipDepartmentReadDto {
  const VoipDepartmentReadDto({
    this.id,
    this.title,
    this.members,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? title;
  final List<UserReadDto>? members;
  final MainFileReadDto? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoipDepartmentReadDto.fromMap(final Map<String, dynamic> json) {
    return VoipDepartmentReadDto(
      id: json['id'] as int?,
      title: json['title'] as String?,
      members: json['members'] == null
          ? null
          : List<UserReadDto>.from(json['members']!.map((final x) => UserReadDto.fromMap(x)).toList()),
      avatar: json['avatar'] == null ? null : MainFileReadDto.fromMap(json['avatar']!),
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}
