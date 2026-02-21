import 'sms_panel_number_dto.dart';

class ReceivedSmsReadDto {
  final int? id;
  final SmsPanelNumberReadDto? receivePhone;
  final String? senderPhone;
  final String? messageId;
  final int? kavenegarMessageId;
  final String? content;
  final DateTime? date;

  const ReceivedSmsReadDto({
    this.id,
    this.receivePhone,
    this.senderPhone,
    this.messageId,
    this.kavenegarMessageId,
    this.content,
    this.date,
  });

  factory ReceivedSmsReadDto.fromMap(final Map<String, dynamic> json) {
    return ReceivedSmsReadDto(
      id: json['id'],
      receivePhone: json['receive_phone'] != null ? SmsPanelNumberReadDto.fromMap(json['receive_phone']) : null,
      senderPhone: json['sender_phone'],
      messageId: json['message_id'],
      kavenegarMessageId: json['kavenegar_message_id'],
      content: json['content'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
    );
  }
}
