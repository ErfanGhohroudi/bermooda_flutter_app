import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';

import '../../../../../../data/data.dart';
import '../../data/models/response/sms_dto.dart';
import '../enums/enums.dart';

class SmsEntity extends Equatable {
  final int id;
  final String content;
  final SMSStatus? status;
  final String? messageId;
  final String? recipient;
  final String? recipientName;
  final int sender;
  final String? senderNumber;
  final String? senderProvider;
  final UserReadDto? sentByUser;
  final String? cost;
  final String? errorMessage;
  final Jalali? sentAt;
  final Jalali? scheduledAt;
  final int? department;
  final Jalali? createdAt;
  final Jalali? updatedAt;


  const SmsEntity({
    required this.id,
    required this.content,
    this.status,
    this.messageId,
    this.recipient,
    this.recipientName,
    this.sender = 0,
    this.senderNumber,
    this.senderProvider,
    this.sentByUser,
    this.cost,
    this.errorMessage,
    this.sentAt,
    this.scheduledAt,
    this.department,
    this.createdAt,
    this.updatedAt,
  });

  factory SmsEntity.fromDto(final SmsReadDto dto) => SmsEntity(
    id: dto.id ?? 0,
    status: SMSStatus.fromString(dto.status),
    content: dto.content ?? '',
    messageId: dto.messageId,
    recipient: dto.recipient,
    recipientName: dto.recipientName,
    sender: dto.sender ?? 0,
    senderNumber: dto.senderNumber,
    senderProvider: dto.senderProvider,
    sentByUser: dto.sentByUser,
    cost: dto.cost,
    errorMessage: dto.errorMessage,
    sentAt: dto.sentAt?.toJalali(),
    scheduledAt: dto.scheduledAt?.toJalali(),
    department: dto.department,
    createdAt: dto.createdAt?.toJalali(),
    updatedAt: dto.updatedAt?.toJalali(),
  );

  @override
  List<Object?> get props => [
    id,
    status?.name,
    content,
    messageId,
    recipient,
    sender,
    senderNumber,
    senderProvider,
    sentByUser,
    cost,
    errorMessage,
    sentAt?.toString(),
    scheduledAt?.toString(),
    department,
    createdAt?.toString(),
    updatedAt?.toString(),
  ];
}
