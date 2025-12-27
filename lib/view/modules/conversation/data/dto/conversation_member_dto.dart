part of 'conversation_dtos.dart';

enum MemberRole {
  owner,
  admin,
  member;

  String get title {
    switch (this) {
      case MemberRole.owner:
        return s.owner;
      case MemberRole.admin:
        return s.admin;
      case MemberRole.member:
        return s.member;
    }
  }

  static MemberRole fromString(final String role) {
    switch (role) {
      case 'owner':
        return MemberRole.owner;
      case 'admin':
        return MemberRole.admin;
      case 'member':
        return MemberRole.member;
      default:
        return MemberRole.member;
    }
  }
}

class ConversationMemberDto extends Equatable {
  const ConversationMemberDto({
    required this.id,
    required this.user,
    required this.role,
    required this.joinedAt,
    this.canSendMessages = true,
    this.canSendMedia = true,
    this.isMuted = false,
    this.isPinned = false,
    this.lastReadAt,
    this.unreadCount = 0,
  });

  final String id;
  final UserBasicDto user;
  final MemberRole role;
  final String joinedAt;
  final bool canSendMessages;
  final bool canSendMedia;
  final bool isMuted;
  final bool isPinned;
  final DateTime? lastReadAt;
  final int unreadCount;

  bool get isOwner => role == MemberRole.owner;

  bool get isAdmin => role == MemberRole.admin;

  bool get isMember => role == MemberRole.member;

  factory ConversationMemberDto.fromJson(final Map<String, dynamic> json) {
    return ConversationMemberDto(
      id: json['id']?.toString() ?? '',
      user: UserBasicDto.fromJson(json['user']),
      role: MemberRole.fromString(json['role'] ?? 'member'),
      joinedAt: json['joined_at'] ?? '',
      canSendMessages: json['can_send_messages'] as bool? ?? true,
      canSendMedia: json['can_send_media'] as bool? ?? true,
      isMuted: json['is_muted'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? false,
      lastReadAt: DateTime.tryParse(json['last_read_at'] as String? ?? ''),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  factory ConversationMemberDto.fromMap(final Map<String, dynamic> json) => ConversationMemberDto.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'role': role.name,
      'joined_at': joinedAt,
      'can_send_messages': canSendMessages,
      'can_send_media': canSendMedia,
      'is_muted': isMuted,
      'is_pinned': isPinned,
      'last_read_at': lastReadAt?.toIso8601String(),
      'unread_count': unreadCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        user,
        role,
        canSendMessages,
        canSendMedia,
        isMuted,
        isPinned,
        unreadCount,
      ];
}
