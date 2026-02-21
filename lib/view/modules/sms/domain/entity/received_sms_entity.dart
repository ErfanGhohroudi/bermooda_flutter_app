import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';
import '../../data/models/response/received_sms_dto.dart';
import 'sms_panel_number.dart';

class ReceivedSmsEntity extends Equatable {
  final int id;
  final SmsPanelNumber? receivePhone;
  final String senderPhone;
  final String messageId;
  final int kavenegarMessageId;
  final String content;
  final Jalali? date;

  const ReceivedSmsEntity({
    required this.id,
    this.receivePhone,
    required this.senderPhone,
    required this.messageId,
    required this.kavenegarMessageId,
    required this.content,
    this.date,
  });

  factory ReceivedSmsEntity.fromDto(final ReceivedSmsReadDto dto) {
    return ReceivedSmsEntity(
      id: dto.id ?? 0,
      receivePhone: dto.receivePhone != null ? SmsPanelNumber.fromDto(dto.receivePhone!) : null,
      senderPhone: dto.senderPhone ?? '',
      messageId: dto.messageId ?? '',
      kavenegarMessageId: dto.kavenegarMessageId ?? 0,
      content: dto.content ?? '',
      date: dto.date?.toJalali(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        receivePhone,
        senderPhone,
        messageId,
        kavenegarMessageId,
        content,
        date,
      ];
}
