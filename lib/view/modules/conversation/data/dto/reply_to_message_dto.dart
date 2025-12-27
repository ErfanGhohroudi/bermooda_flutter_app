part of 'conversation_dtos.dart';

class ReplyToMessageDto extends Equatable {
  const ReplyToMessageDto({
    required this.id,
    required this.sender,
    required this.type,
    this.text,
    required this.createdAt,
  });

  final String id;
  final UserBasicDto sender;
  final MessageType type;
  final String? text;
  final DateTime createdAt;

  factory ReplyToMessageDto.fromJson(final Map<String, dynamic> json) {
    return ReplyToMessageDto(
      id: json['id']?.toString() ?? '',
      sender: UserBasicDto.fromJson(json['sender']),
      type: MessageType.fromString(json['type']),
      text: json['text'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  factory ReplyToMessageDto.fromMap(final Map<String, dynamic> json) => ReplyToMessageDto.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'type': type.name,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, sender, type.name, text, createdAt.toIso8601String()];
}

