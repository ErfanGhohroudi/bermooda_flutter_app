import '../../../../../../data/data.dart';

class GroupSmsReadDto {
  final int? id;
  final String? title;
  final String? content;
  final int? deliveredCount;
  final List<String>? duplicateRecipients;
  final int? failedCount;
  final List<String>? invalidRecipients;
  final String? messageId;
  final List<String>? recipients;
  final int? sender;
  final String? senderNumber;
  final String? senderProvider;
  final UserReadDto? sentByUser;
  final int? sentCount;
  final String? status;
  final double? successRate;
  final String? totalCost;
  final int? totalRecipients;
  final List<String>? validRecipients;
  final DateTime? scheduledAt;
  final int? department;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GroupSmsReadDto({
    this.id,
    this.title,
    this.content,
    this.deliveredCount,
    this.duplicateRecipients,
    this.failedCount,
    this.invalidRecipients,
    this.messageId,
    this.recipients,
    this.sender,
    this.senderNumber,
    this.senderProvider,
    this.sentByUser,
    this.sentCount,
    this.status,
    this.successRate,
    this.totalCost,
    this.totalRecipients,
    this.validRecipients,
    this.scheduledAt,
    this.department,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupSmsReadDto.fromMap(final Map<String, dynamic> json) => GroupSmsReadDto(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    deliveredCount: json["delivered_count"],
    duplicateRecipients: json["duplicate_recipients"]?.cast<String>(),
    failedCount: json["failed_count"],
    invalidRecipients: json["invalid_recipients"]?.cast<String>(),
    messageId: json["message_id"],
    recipients: json["recipients"]?.cast<String>(),
    sender: json["sender"],
    senderNumber: json["sender_number"],
    senderProvider: json["sender_provider"],
    sentByUser: json["sent_by_user"] == null ? null : UserReadDto.fromMap(json["sent_by_user"]!),
    sentCount: json["sent_count"],
    status: json["status"],
    successRate: json["success_rate"],
    totalCost: json["total_cost"],
    totalRecipients: json["total_recipients"],
    validRecipients: json["valid_recipients"]?.cast<String>(),
    scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ''),
    department: json["department"],
    createdAt: DateTime.tryParse(json["created_at"] ?? ''),
    updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
  );
}
