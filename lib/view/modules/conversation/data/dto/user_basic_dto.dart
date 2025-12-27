part of 'conversation_dtos.dart';

class UserBasicDto extends UserReadDto {
  const UserBasicDto({
    required super.id,
    super.fullName,
    super.avatarUrl,
    this.isOnline = false,
  });

  final bool isOnline;

  factory UserBasicDto.fromJson(final Map<String, dynamic> json) {
    return UserBasicDto(
      id: json['id'].toString(),
      fullName: json['fullname'],
      avatarUrl: json['avatar_url'],
      isOnline: json['is_online'] ?? false,
    );
  }

  factory UserBasicDto.fromMap(final Map<String, dynamic> json) => UserBasicDto.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullName,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
    };
  }

  @override
  List<Object?> get props => [id, fullName, avatarUrl, isOnline];
}

