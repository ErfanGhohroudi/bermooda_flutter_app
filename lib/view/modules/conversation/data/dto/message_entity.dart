part of 'conversation_dtos.dart';

abstract class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.createdAt,
  });

  final String id;
  final DateTime createdAt;

  bool get isOwner;

  String? get messageText;

  MessageEntity copyWith();


  factory MessageEntity.fromJson(final Map<String, dynamic> json) {
    final isFeedback = json['priority'] != null;

    if (isFeedback) {
      return FeedbackDto.fromMap(json);
    } else {
      return MessageDto.fromMap(json);
    }
  }

  factory MessageEntity.fromMap(final Map<String, dynamic> json) => MessageEntity.fromJson(json);

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [];
}

