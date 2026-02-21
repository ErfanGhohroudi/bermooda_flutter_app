import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../data/data.dart';
import '../../data/models/support_department_dto.dart';

class SupportDepartment extends Equatable {
  final int id;
  final String title;
  final MainFileReadDto? avatar;
  final Color? color;
  final String slug;
  final String supportingSlug;
  final List<UserReadDto> members;
  final int memberCount;
  final int totalChats;
  final int openChats;
  final int closedChats;
  final int waitingForReply;
  final ProjectStatusEntity projectStatus;
  final bool publicChatEnabled;
  final String? publicChatUrl;

  const SupportDepartment({
    required this.id,
    required this.title,
    this.avatar,
    this.color,
    required this.slug,
    required this.supportingSlug,
    this.members = const [],
    this.memberCount = 0,
    this.totalChats = 0,
    this.openChats = 0,
    this.closedChats = 0,
    this.waitingForReply = 0,
    required this.projectStatus,
    this.publicChatEnabled = false,
    this.publicChatUrl,
  });

  factory SupportDepartment.fromDto(final SupportDepartmentReadDto dto) {
    return SupportDepartment(
      id: dto.id ?? 0,
      title: dto.title ?? '',
      avatar: dto.avatar,
      color: dto.colorCode?.toColor(),
      slug: dto.slug ?? '',
      supportingSlug: dto.supportingSlug ?? '',
      members: dto.members ?? [],
      memberCount: dto.memberCount ?? 0,
      totalChats: dto.totalChats ?? 0,
      openChats: dto.openChats ?? 0,
      closedChats: dto.closedChats ?? 0,
      waitingForReply: dto.waitingForReply ?? 0,
      projectStatus: dto.projectStatus != null
          ? ProjectStatusEntity.fromDto(dto.projectStatus!)
          : const ProjectStatusEntity(),
      publicChatEnabled: dto.publicChatEnabled ?? false,
      publicChatUrl: dto.publicChatUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        avatar,
        color,
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

class ProjectStatusEntity extends Equatable {
  final int waitingForReplyPercentage;
  final int openChatPercentage;
  final int closedPercentage;

  const ProjectStatusEntity({
    this.waitingForReplyPercentage = 0,
    this.openChatPercentage = 0,
    this.closedPercentage = 0,
  });

  factory ProjectStatusEntity.fromDto(final ProjectStatusDto dto) {
    return ProjectStatusEntity(
      waitingForReplyPercentage: dto.waitingForReplyPercentage ?? 0,
      openChatPercentage: dto.openChatPercentage ?? 0,
      closedPercentage: dto.closedPercentage ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        waitingForReplyPercentage,
        openChatPercentage,
        closedPercentage,
      ];
}
