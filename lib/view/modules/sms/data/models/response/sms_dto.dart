import '../../../../../../data/data.dart';

class SmsReadDto {
  final int? id;
  final String? content;
  final String? messageId;
  final String? recipient;
  final String? recipientName;
  final int? sender;
  final String? senderNumber;
  final String? senderProvider;
  final UserReadDto? sentByUser;
  final String? cost;
  final String? status;
  final String? errorMessage;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final int? department;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SmsReadDto({
    this.id,
    this.content,
    this.messageId,
    this.recipient,
    this.recipientName,
    this.sender,
    this.senderNumber,
    this.senderProvider,
    this.sentByUser,
    this.cost,
    this.status,
    this.errorMessage,
    this.scheduledAt,
    this.sentAt,
    this.department,
    this.createdAt,
    this.updatedAt,
  });

  factory SmsReadDto.fromMap(final Map<String, dynamic> json) => SmsReadDto(
    id: json["id"],
    content: json["content"],
    messageId: json["message_id"],
    recipient: json["recipient"],
    recipientName: json["recipient_name"],
    sender: json["sender"],
    senderNumber: json["sender_number"],
    senderProvider: json["sender_provider"],
    sentByUser: json["sent_by_user"] == null ? null : UserReadDto.fromMap(json["sent_by_user"]!),
    cost: json["cost"],
    status: json["status"],
    errorMessage: json["error_message"],
    scheduledAt: DateTime.tryParse(json["scheduled_at"] ?? ''),
    sentAt: DateTime.tryParse(json["sent_at"] ?? ''),
    department: json["department"],
    createdAt: DateTime.tryParse(json["created_at"] ?? ''),
    updatedAt: DateTime.tryParse(json["updated_at"] ?? ''),
  );
}
