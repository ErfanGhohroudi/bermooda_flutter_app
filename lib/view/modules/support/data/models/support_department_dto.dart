import 'package:equatable/equatable.dart';

import '../../../../../data/data.dart';

class SupportDepartmentReadDto extends Equatable {
  final int? id;
  final String? title;
  final MainFileReadDto? avatar;
  final String? colorCode;
  final String? slug;
  final String? supportingSlug;
  final List<UserReadDto>? members;
  final int? memberCount;
  final int? totalChats;
  final int? openChats;
  final int? closedChats;
  final int? waitingForReply;
  final ProjectStatusDto? projectStatus;
  final bool? publicChatEnabled;
  final String? publicChatUrl;

  const SupportDepartmentReadDto({
    this.id,
    this.title,
    this.avatar,
    this.colorCode,
    this.slug,
    this.supportingSlug,
    this.members,
    this.memberCount,
    this.totalChats,
    this.openChats,
    this.closedChats,
    this.waitingForReply,
    this.projectStatus,
    this.publicChatEnabled,
    this.publicChatUrl,
  });

  factory SupportDepartmentReadDto.fromMap(final Map<String, dynamic> json) {
    return SupportDepartmentReadDto(
      id: json['id'],
      title: json['title'],
      avatar: json['avatar'] == null ? null : MainFileReadDto.fromMap(json['avatar']!),
      colorCode: json['color_code'],
      slug: json['slug'],
      supportingSlug: json['supporting_slug'],
      members: json['members'] != null ? (json['members'] as List).map((final e) => UserReadDto.fromMap(e)).toList() : null,
      memberCount: json['member_count'],
      totalChats: json['total_chats'],
      openChats: json['open_chats'],
      closedChats: json['closed_chats'],
      waitingForReply: json['waiting_for_reply'],
      projectStatus: json['project_status'] != null ? ProjectStatusDto.fromMap(json['project_status']) : null,
      publicChatEnabled: json['public_chat_enabled'],
      publicChatUrl: json['public_chat_url'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    colorCode,
    slug,
    supportingSlug,
    members,
    memberCount,
    totalChats,
    openChats,
    closedChats,
    waitingForReply,
    projectStatus,
    publicChatEnabled,
    publicChatUrl,
  ];
}

class ProjectStatusDto extends Equatable {
  final int? waitingForReplyPercentage;
  final int? openChatPercentage;
  final int? closedPercentage;

  const ProjectStatusDto({
    this.waitingForReplyPercentage,
    this.openChatPercentage,
    this.closedPercentage,
  });

  factory ProjectStatusDto.fromMap(final Map<String, dynamic> json) {
    return ProjectStatusDto(
      waitingForReplyPercentage: json['waiting_for_reply_percentage'],
      openChatPercentage: json['open_chat_percentage'],
      closedPercentage: json['closed_percentage'],
    );
  }

  @override
  List<Object?> get props => [
    waitingForReplyPercentage,
    openChatPercentage,
    closedPercentage,
  ];
}
