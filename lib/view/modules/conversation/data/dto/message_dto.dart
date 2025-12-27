part of 'conversation_dtos.dart';

class MessageDto extends MessageEntity {
  const MessageDto({
    required super.id,
    required super.createdAt,
    required this.conversationId,
    required this.sender,
    required this.type,
    this.text,
    this.attachments,
    this.replyTo,
    required this.repliesCount,
    this.forwardedFrom,
    required this.forwardCount,
    required this.status,
    required this.isEdited,
    required this.isPinned,
    required this.isOwn,
    this.clientId,
    this.jalaliTime,
    this.duration,
    this.userReactions = const [],
    this.reactions = const [],
    this.uploadProgress,
    // this.isUploading = false,
    this.localFilePath,
    this.uploadError,
  });

  final String conversationId;
  final UserBasicDto sender;
  final MessageType type;
  final String? text;
  final List<MessageAttachmentDto>? attachments;
  final ReplyToMessageDto? replyTo;
  final int repliesCount;
  final ForwardedFromDto? forwardedFrom;
  final int forwardCount;
  final MessageStatus status;
  final bool isEdited;
  final bool isPinned;
  final bool isOwn;
  final String? clientId;
  final String? jalaliTime;
  final int? duration;
  final List<UserReactionDto> userReactions;
  final List<ReactionDto> reactions;
  final double? uploadProgress;
  final String? localFilePath;
  final String? uploadError;

  @override
  String? get messageText => type.title ?? text;

  @override
  bool get isOwner => sender.id == Get.find<Core>().userReadDto.value.id;

  bool get isFailed => isOwner && status == MessageStatus.failed;
  bool get isSending => isOwner && status == MessageStatus.sending;

  factory MessageDto.fromMap(final Map<String, dynamic> json) {
    return MessageDto(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      sender: UserBasicDto.fromJson(json['sender']),
      type: MessageType.fromString(json['type']),
      text: json['text'],
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((final e) => MessageAttachmentDto.fromJson(e))
              .toList()
          : null,
      replyTo: json['reply_to'] != null
          ? ReplyToMessageDto.fromJson(json['reply_to'])
          : null,
      repliesCount: json['replies_count'] ?? 0,
      forwardedFrom: json['forwarded_from'] != null
          ? ForwardedFromDto.fromJson(json['forwarded_from'])
          : null,
      forwardCount: json['forward_count'] ?? 0,
      status: MessageStatus.fromString(json['status']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
      isEdited: json['is_edited'] ?? false,
      isPinned: json['is_pinned'] ?? false,
      isOwn: json['is_own'] ?? false,
      clientId: json['client_id']?.toString(),
      jalaliTime: json['jalali_time'],
      duration: json['duration'],
      userReactions: json['user_reactions'] != null
          ? List<UserReactionDto>.from(json['user_reactions']
              .map((final x) => UserReactionDto.fromMap(x)))
          : [],
      reactions: json['reaction_list'] != null
          ? List<ReactionDto>.from(
              json['reaction_list'].map((final x) => ReactionDto.fromMap(x)))
          : [],
      uploadProgress: null, // Not from server
      localFilePath: null, // Not from server
      uploadError: null, // Not from server
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender': sender.toJson(),
      'type': type.name,
      'text': text,
      'attachments': attachments?.map((final e) => e.toJson()).toList(),
      'reply_to': replyTo?.toJson(),
      'replies_count': repliesCount,
      'forwarded_from': forwardedFrom?.toJson(),
      'forward_count': forwardCount,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'is_edited': isEdited,
      'is_pinned': isPinned,
      'is_own': isOwn,
      'client_id': clientId,
      'jalali_time': jalaliTime,
      'duration': duration,
      'user_reactions': userReactions.map((final e) => e.toJson()).toList(),
      'reaction_list': reactions.map((final e) => e.toJson()).toList(),
      // uploadProgress, isUploading, localFilePath, uploadError are client-side only
    };
  }

  @override
  MessageDto copyWith({
    final String? id,
    final String? conversationId,
    final UserBasicDto? sender,
    final MessageType? type,
    final String? text,
    final List<MessageAttachmentDto>? attachments,
    final ReplyToMessageDto? replyTo,
    final int? repliesCount,
    final ForwardedFromDto? forwardedFrom,
    final int? forwardCount,
    final MessageStatus? status,
    final DateTime? createdAt,
    final bool? isEdited,
    final bool? isPinned,
    final bool? isOwn,
    final String? clientId,
    final String? jalaliTime,
    final int? duration,
    final List<UserReactionDto>? userReactions,
    final List<ReactionDto>? reactions,
    final double? uploadProgress,
    final String? localFilePath,
    final String? uploadError,
  }) {
    return MessageDto(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      replyTo: replyTo ?? this.replyTo,
      repliesCount: repliesCount ?? this.repliesCount,
      forwardedFrom: forwardedFrom ?? this.forwardedFrom,
      forwardCount: forwardCount ?? this.forwardCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isEdited: isEdited ?? this.isEdited,
      isPinned: isPinned ?? this.isPinned,
      isOwn: isOwn ?? this.isOwn,
      clientId: clientId ?? this.clientId,
      jalaliTime: jalaliTime ?? this.jalaliTime,
      duration: duration ?? this.duration,
      userReactions: userReactions ?? this.userReactions,
      reactions: reactions ?? this.reactions,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      localFilePath: localFilePath ?? this.localFilePath,
      uploadError: uploadError ?? this.uploadError,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        sender,
        type,
        text,
        attachments,
        replyTo,
        repliesCount,
        forwardedFrom,
        forwardCount,
        status,
        createdAt.toIso8601String(),
        isEdited,
        isPinned,
        isOwn,
        clientId,
        jalaliTime,
        duration,
        userReactions,
        reactions,
        uploadProgress,
        localFilePath,
        uploadError,
      ];
}

class UserReactionDto extends Equatable {
  const UserReactionDto({
    required this.id,
    required this.user,
    required this.emoji,
  });

  final String id;
  final UserBasicDto user;
  final String emoji;

  factory UserReactionDto.fromMap(final Map<String, dynamic> json) {
    return UserReactionDto(
      id: json['id']?.toString() ?? '',
      user: UserBasicDto.fromMap(json["user"]),
      emoji: json['emoji']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'emoji': emoji,
    };
  }

  UserReactionDto copyWith({
    final String? id,
    final UserBasicDto? user,
    final String? emoji,
  }) {
    return UserReactionDto(
      id: id ?? this.id,
      user: user ?? this.user,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        emoji,
      ];
}

class ReactionDto extends Equatable {
  const ReactionDto({
    required this.emoji,
    required this.count,
    required this.isUserIn,
  });

  final String emoji;
  final int count;
  final bool isUserIn;

  factory ReactionDto.fromMap(final Map<String, dynamic> json) {
    return ReactionDto(
      emoji: json['emoji']?.toString() ?? '',
      count: json['count'] ?? 0,
      isUserIn: json['is_user_in'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'count': count,
      'is_user_in': isUserIn,
    };
  }

  ReactionDto copyWith({
    final String? emoji,
    final int? count,
    final bool? isUserIn,
  }) {
    return ReactionDto(
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
      isUserIn: isUserIn ?? this.isUserIn,
    );
  }

  @override
  List<Object?> get props => [
        emoji,
        count,
        isUserIn,
      ];
}
