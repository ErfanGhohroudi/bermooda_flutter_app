part of '../../../data.dart';

class BoardMemberReadDto extends Equatable {
  const BoardMemberReadDto({
    this.id,
    this.userId,
    this.type,
    this.fullName,
    this.avatar,
    this.isAccepted = false,
    this.requests = const [],
  });

  final int? id;
  final int? userId;
  final OwnerMemberType? type;
  final String? fullName;
  final MainFileReadDto? avatar;
  final bool isAccepted;
  final List<IRequestReadDto> requests;

  factory BoardMemberReadDto.fromJson(final String str) => BoardMemberReadDto.fromMap(json.decode(str));

  factory BoardMemberReadDto.fromMap(final Map<String, dynamic> json) => BoardMemberReadDto(
        id: json["id"],
        userId: json["user_id"],
        type: json["user_type"] == null ? null : OwnerMemberType.values.firstWhereOrNull((final e) => e.name == json["user_type"]),
        fullName: json["fullname"],
        avatar: json["avatar"] == null ? null : MainFileReadDto.fromMap(json["avatar"]),
        isAccepted: json["is_accepted"] ?? false,
        requests: json["member_employee_request"] == null ? [] : RequestEntityFactory.createResponseListFromMaps(json["member_employee_request"]),
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        fullName,
        avatar,
        requests.map((final e) => e.toMap()).toList(),
      ];
}
