part of 'conversation_dtos.dart';

enum ConversationType {
  direct,
  group,
  bot;

  String get value {
    switch (this) {
      case ConversationType.direct:
        return 'direct';
      case ConversationType.group:
        return 'group';
      case ConversationType.bot:
        return 'bot';
    }
  }

  static ConversationType fromString(final String? type) {
    switch (type) {
      case 'direct':
        return ConversationType.direct;
      case 'group':
        return ConversationType.group;
      case 'bot':
        return ConversationType.bot;
      default:
        return ConversationType.direct;
    }
  }
}

enum BotType {
  anonymous_bot,
  survey_bot;

  static BotType? fromString(final String? type) {
    switch (type) {
      case 'anonymous_bot':
        return BotType.anonymous_bot;
      case 'survey_bot':
        return BotType.survey_bot;
      default:
        return null;
    }
  }
}

class ConversationDto extends Equatable {
  const ConversationDto({
    required this.id,
    required this.type,
    this.botType,
    this.title,
    this.description,
    required this.displayName,
    this.avatarUrl,
    required this.members,
    this.lastMessage,
    required this.unreadCount,
    required this.lastMessageAt,
  });

  final String id;
  final ConversationType type;
  final String? title;
  final BotType? botType;
  final String? description;
  final String displayName;
  final String? avatarUrl;
  final List<ConversationMemberDto> members;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime lastMessageAt;

  factory ConversationDto.fromMap(final Map<String, dynamic> json) {
    return ConversationDto(
      id: json['id']?.toString() ?? '',
      type: ConversationType.fromString(json['type']),
      title: json['title'],
      botType: BotType.fromString(json['bot_type']),
      description: json['description'],
      displayName: json['display_name'] ?? '',
      avatarUrl: json['avatar_url'],
      members: json['members'] != null ? (json['members'] as List).map((final e) => ConversationMemberDto.fromJson(e)).toList() : [],
      lastMessage: json['last_message'] != null ? MessageEntity.fromMap(json['last_message']) : null,
      unreadCount: json['unread_count'] ?? 0,
      lastMessageAt: DateTime.tryParse(json['last_message_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'description': description,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'members': members.map((final e) => e.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'last_message_at': lastMessageAt.toIso8601String(),
    };
  }

  ConversationDto copyWith({
    final String? id,
    final ConversationType? type,
    final String? title,
    final BotType? botType,
    final String? description,
    final String? displayName,
    final String? avatarUrl,
    final List<ConversationMemberDto>? members,
    final MessageEntity? lastMessage,
    final int? unreadCount,
    final DateTime? lastMessageAt,
  }) {
    return ConversationDto(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      botType: botType ?? this.botType,
      description: description ?? this.description,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        botType,
        description,
        displayName,
        avatarUrl,
        members,
        lastMessage,
        unreadCount,
        lastMessageAt.toIso8601String(),
      ];
}
