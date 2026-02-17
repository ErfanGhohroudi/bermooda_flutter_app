import 'package:equatable/equatable.dart';

import '../../../../../data/data.dart';
import '../../data/dto/response/sms_departments.dart';

class SmsDepartment extends Equatable {
  const SmsDepartment({
    required this.id,
    required this.title,
    required this.members,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final List<UserReadDto> members;
  final MainFileReadDto? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SmsDepartment.fromDto(final SmsDepartmentReadDto dto) {
    return SmsDepartment(
      id: dto.id ?? 0,
      title: dto.title ?? '',
      members: dto.members ?? [],
      avatar: dto.avatar,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    members,
    createdAt,
    updatedAt,
  ];
}
