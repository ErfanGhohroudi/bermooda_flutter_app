import 'package:bermooda_business/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';
import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../data/models/support_room_dto.dart';
import '../enums/message_type.dart';
import '../enums/room_status.dart';
import 'support_section.dart';

class SupportRoomEntity extends Equatable {
  final int id;
  final SupportRoomStatus status;
  final UserReadDto? assignedOperator;
  final UserReadDto? anonymousUser;
  final SupportLastMessageEntity? lastMessage;
  final int unreadCount;
  final String persianCreated;
  final double rating;
  final int messageCount;
  final SupportSection? section;
  final String widgetCode;
  final String departmentTitle;

  const SupportRoomEntity({
    required this.id,
    required this.status,
    this.assignedOperator,
    this.anonymousUser,
    this.lastMessage,
    required this.unreadCount,
    required this.persianCreated,
    required this.rating,
    required this.messageCount,
    this.section,
    required this.widgetCode,
    required this.departmentTitle,
  });

  factory SupportRoomEntity.fromDto(final SupportRoomReadDto dto) {
    return SupportRoomEntity(
      id: dto.id ?? 0,
      status: SupportRoomStatus.fromString(dto.roomStatus),
      assignedOperator: dto.assignedOperator,
      anonymousUser: dto.anonymousUser,
      lastMessage: dto.lastMessage != null ? SupportLastMessageEntity.fromDto(dto.lastMessage!) : null,
      unreadCount: dto.unreadCount ?? 0,
      persianCreated: dto.persianCreated ?? '',
      rating: dto.rating ?? 0,
      messageCount: dto.messageCount ?? 0,
      section: dto.label != null ? SupportSection.fromDto(dto.label!) : null,
      widgetCode: dto.widgetCode ?? '',
      departmentTitle: dto.departmentTitle ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    status.name,
    assignedOperator,
    anonymousUser,
    lastMessage,
    unreadCount,
    persianCreated,
    rating,
    messageCount,
    section,
    widgetCode,
    departmentTitle,
  ];
}

class SupportLastMessageEntity extends Equatable {
  final String body;
  final SupportMessageType type;
  final DateTime? created;

  const SupportLastMessageEntity({
    required this.body,
    required this.type,
    required this.created,
  });

  factory SupportLastMessageEntity.fromDto(final SupportLastMessageDto dto) {
    final createdString = dto.created;
    Jalali? date;

    if (createdString != null && createdString.isNotEmpty) {
      try {
        final parts = createdString.split(' ');
        if (parts.length == 2) {
          date = parts[0].toJalali();
          final time = parts[1];
          if (time.contains(':')) {
            final hour = time.split(':').first.toInt();
            final minute = time.split(':')[1].toInt();
            date = date?.copyWith(hour: hour, minute: minute);
          }
        }
      } catch (e) {}
    }

    return SupportLastMessageEntity(
      body: dto.body ?? '',
      type: SupportMessageType.fromString(dto.type),
      created: date?.toDateTime(),
    );
  }

  @override
  List<Object?> get props => [body, type.name, created];
}
