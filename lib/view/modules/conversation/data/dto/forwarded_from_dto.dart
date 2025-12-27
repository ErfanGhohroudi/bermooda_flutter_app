part of 'conversation_dtos.dart';

class ForwardedFromDto extends Equatable {
  const ForwardedFromDto({
    required this.user,
    required this.forwardedAt,
    required this.originalConversationName,
  });

  final UserBasicDto user;
  final String forwardedAt;
  final String originalConversationName;

  factory ForwardedFromDto.fromJson(final Map<String, dynamic> json) {
    return ForwardedFromDto(
      user: UserBasicDto.fromJson(json['user']),
      forwardedAt: json['forwarded_at'] ?? '',
      originalConversationName: json['original_conversation_name'] ?? '',
    );
  }

  factory ForwardedFromDto.fromMap(final Map<String, dynamic> json) => ForwardedFromDto.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'forwarded_at': forwardedAt,
      'original_conversation_name': originalConversationName,
    };
  }

  @override
  List<Object?> get props => [user, forwardedAt, originalConversationName];
}

