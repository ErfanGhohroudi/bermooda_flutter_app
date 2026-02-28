import 'package:equatable/equatable.dart';
import 'package:bermooda_business/data/data.dart';

import '../enums/message_type.dart';

class SupportMessage extends Equatable {
  final String id;
  final SupportMessageType type;
  final String body;
  final bool isOperator;
  final DateTime created;
  final MainFileReadDto? file;
  final MainFileReadDto? voice;
  final MainFileReadDto? image;
  final UserReadDto? operatorUser;
  final UserReadDto? anonymousUser;
  final SupportMessage? reply;
  final bool readStatus;
  final String? clientId;

  // Local Variables
  final double? uploadProgress;
  final String? uploadError;
  final bool isSending;
  final bool isFailed;

  const SupportMessage({
    required this.id,
    required this.type,
    required this.body,
    required this.isOperator,
    required this.created,
    this.file,
    this.voice,
    this.image,
    this.operatorUser,
    this.anonymousUser,
    this.reply,
    required this.readStatus,
    this.clientId,
    this.uploadProgress,
    this.uploadError,
    this.isSending = false,
    this.isFailed = false,
  });

  SupportMessage copyWith({
    final SupportMessageType? type,
    final String? body,
    final bool? isOperator,
    final DateTime? created,
    final MainFileReadDto? file,
    final MainFileReadDto? voice,
    final MainFileReadDto? image,
    final UserReadDto? operatorUser,
    final UserReadDto? anonymousUser,
    final SupportMessage? reply,
    final bool? readStatus,
    final String? clientId,
    final double? uploadProgress,
    final String? uploadError,
    final bool? isSending,
    final bool? isFailed,
  }) {
    return SupportMessage(
      id: id,
      type: type ?? this.type,
      body: body ?? this.body,
      isOperator: isOperator ?? this.isOperator,
      created: created ?? this.created,
      file: file ?? this.file,
      voice: voice ?? this.voice,
      image: image ?? this.image,
      operatorUser: operatorUser ?? this.operatorUser,
      anonymousUser: anonymousUser ?? this.anonymousUser,
      reply: reply ?? this.reply,
      readStatus: readStatus ?? this.readStatus,
      clientId: clientId ?? this.clientId,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadError: uploadError ?? this.uploadError,
      isSending: isSending ?? this.isSending,
      isFailed: isFailed ?? this.isFailed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type.name,
        body,
        isOperator,
        created,
        file,
        voice,
        image,
        operatorUser,
        anonymousUser,
        reply,
        readStatus,
        clientId,
        uploadProgress,
        uploadError,
        isSending,
        isFailed,
      ];
}
