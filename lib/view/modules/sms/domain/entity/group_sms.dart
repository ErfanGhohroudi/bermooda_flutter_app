import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../data/models/response/group_sms_dto.dart';
import '../enums/enums.dart';

class GroupSmsEntity extends Equatable {
  final int id;
  final String title;
  final GroupSMSStatus? status;
  final String content;
  final int deliveredCount;
  final int failedCount;
  final int sentCount;
  final List<String> duplicateRecipients;
  final List<String> invalidRecipients;
  final String? messageId;
  final List<String> recipients;
  final int sender;
  final String? senderNumber;
  final String? senderProvider;
  final UserReadDto? sentByUser;
  final double successRate;
  final String? totalCost;
  final int totalRecipients;
  final List<String> validRecipients;
  final Jalali? scheduledAt;
  final int? department;
  final Jalali? createdAt;
  final Jalali? updatedAt;

  const GroupSmsEntity({
    required this.id,
    required this.title,
    required this.content,
    this.status,
    this.deliveredCount = 0,
    this.failedCount = 0,
    this.sentCount = 0,
    this.duplicateRecipients = const [],
    this.invalidRecipients = const [],
    this.messageId,
    this.recipients = const [],
    this.sender = 0,
    this.senderNumber,
    this.senderProvider,
    this.sentByUser,
    this.successRate = 0,
    this.totalCost,
    this.totalRecipients = 0,
    this.validRecipients = const [],
    this.scheduledAt,
    this.department,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupSmsEntity.fromDto(final GroupSmsReadDto dto) => GroupSmsEntity(
    id: dto.id ?? 0,
    title: dto.title ?? '',
    status: GroupSMSStatus.fromString(dto.status),
    content: dto.content ?? '',
    deliveredCount: dto.deliveredCount ?? 0,
    failedCount: dto.failedCount ?? 0,
    sentCount: dto.sentCount ?? 0,
    duplicateRecipients: dto.duplicateRecipients ?? [],
    invalidRecipients: dto.invalidRecipients ?? [],
    messageId: dto.messageId,
    recipients: dto.recipients ?? [],
    sender: dto.sender ?? 0,
    senderNumber: dto.senderNumber,
    senderProvider: dto.senderProvider,
    sentByUser: dto.sentByUser,
    successRate: dto.successRate ?? 0,
    totalCost: dto.totalCost,
    totalRecipients: dto.totalRecipients ?? 0,
    validRecipients: dto.validRecipients ?? [],
    scheduledAt: dto.scheduledAt?.toJalali(),
    department: dto.department,
    createdAt: dto.createdAt?.toJalali(),
    updatedAt: dto.updatedAt?.toJalali(),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    status?.name,
    content,
    deliveredCount,
    failedCount,
    sentCount,
    duplicateRecipients,
    invalidRecipients,
    messageId,
    recipients,
    sender,
    senderNumber,
    senderProvider,
    sentByUser,
    successRate,
    totalCost,
    totalRecipients,
    validRecipients,
    scheduledAt?.toString(),
    department,
    createdAt?.toString(),
    updatedAt?.toString(),
  ];
}
