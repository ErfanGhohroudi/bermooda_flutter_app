part of '../../../data.dart';

class OnlineUsersSummeryReadDto extends Equatable {
  const OnlineUsersSummeryReadDto({
    this.onlineUsersCount = 0,
    this.allUsersCount = 0,
  });

  final int onlineUsersCount;
  final int allUsersCount;

  factory OnlineUsersSummeryReadDto.fromJson(final String str) => OnlineUsersSummeryReadDto.fromMap(json.decode(str));

  factory OnlineUsersSummeryReadDto.fromMap(final Map<String, dynamic> json) => OnlineUsersSummeryReadDto(
        onlineUsersCount: json["online_user_count"] ?? 0,
        allUsersCount: json["all_user_count"] ?? 0,
      );

  @override
  List<Object?> get props => [
        onlineUsersCount,
        allUsersCount,
      ];
}
