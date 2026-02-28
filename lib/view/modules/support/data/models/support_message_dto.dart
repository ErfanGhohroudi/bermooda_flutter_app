import 'package:bermooda_business/data/data.dart';
import '../../domain/entities/support_message.dart';
import '../../domain/enums/message_type.dart';

class SupportMessageDto {
  final String? id;
  final String? clientId;
  final int? roomId;
  final String? body;
  final MainFileReadDto? file;
  final MainFileReadDto? voice;
  final MainFileReadDto? image;
  final String? jTime;
  final UserReadDto? operator;
  final UserReadDto? anonymousUser;
  final DateTime? created;
  final SupportMessageDto? reply;
  final bool? readStatus;
  final String? messageData;
  final String? messageType;

  const SupportMessageDto({
    this.id,
    this.clientId,
    this.roomId,
    this.body,
    this.file,
    this.voice,
    this.image,
    this.jTime,
    this.operator,
    this.anonymousUser,
    this.created,
    this.reply,
    this.readStatus,
    this.messageData,
    this.messageType,
  });

  factory SupportMessageDto.fromMap(final Map<String, dynamic> json) {
    return SupportMessageDto(
      id: json['id'] as String?,
      clientId: json['client_id'] as String?,
      roomId: json['room_id'] as int?,
      body: json['body'] as String?,
      file: json['file'] != null ? MainFileReadDto.fromMap(json['file']) : null,
      voice: json['voice'] != null ? MainFileReadDto.fromMap(json['voice']) : null,
      image: json['image'] != null ? MainFileReadDto.fromMap(json['image']) : null,
      jTime: json['jtime'] as String?,
      operator: json['operator'] != null ? UserReadDto.fromMap(json['operator']) : null,
      anonymousUser: json['anonymous_user'] != null ? UserReadDto.fromMap(json['anonymous_user']) : null,
      created: json['created'] != null ? DateTime.tryParse(json['created']) : null,
      reply: json['reply'] != null ? SupportMessageDto.fromMap(json['reply']) : null,
      readStatus: json['read_status'] as bool?,
      messageData: json['message_data'] as String?,
      messageType: json['message_type'] as String?,
    );
  }

  SupportMessage toEntity() {
    return SupportMessage(
      id: id ?? '0',
      type: SupportMessageType.fromString(messageType),
      body: body ?? '',
      isOperator: messageType == 'operator',
      created: created ?? DateTime.now(),
      file: file,
      voice: voice,
      image: image,
      operatorUser: operator,
      anonymousUser: anonymousUser,
      reply: reply?.toEntity(),
      readStatus: readStatus ?? false,
      clientId: clientId,
    );
  }
}
