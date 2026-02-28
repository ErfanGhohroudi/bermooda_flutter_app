import '../../../../../data/data.dart';
import 'support_section_dto.dart';

class SupportRoomReadDto {
  final int? id;
  final String? roomStatus;
  final UserReadDto? assignedOperator;
  final UserReadDto? anonymousUser;
  final SupportLastMessageDto? lastMessage;
  final int? unreadCount;
  final String? persianCreated;
  final double? rating;
  final int? messageCount;
  final SupportSectionReadDto? label;
  final String? widgetCode;
  final String? departmentTitle;

  const SupportRoomReadDto({
    this.id,
    this.roomStatus,
    this.assignedOperator,
    this.anonymousUser,
    this.lastMessage,
    this.unreadCount,
    this.persianCreated,
    this.rating,
    this.messageCount,
    this.label,
    this.widgetCode,
    this.departmentTitle,
  });

  factory SupportRoomReadDto.fromMap(final Map<String, dynamic> json) {
    return SupportRoomReadDto(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      roomStatus: json['room_status'],
      assignedOperator: json['assigned_operator'] != null ? UserReadDto.fromMap(json['assigned_operator']) : null,
      anonymousUser: json['anonymous_user'] != null ? UserReadDto.fromMap(json['anonymous_user']) : null,
      lastMessage: json['last_message'] != null ? SupportLastMessageDto.fromMap(json['last_message']) : null,
      unreadCount: json['unread_count'] is int ? json['unread_count'] : int.tryParse(json['unread_count']?.toString() ?? ''),
      persianCreated: json['persian_created'],
      rating: json['rating'] is double ? json['rating'] : double.tryParse(json['rating']?.toString() ?? ''),
      messageCount: json['message_count'] is int ? json['message_count'] : int.tryParse(json['message_count']?.toString() ?? ''),
      label: json['label'] != null ? SupportSectionReadDto.fromMap(json['label']) : null,
      widgetCode: json['widget_code'],
      departmentTitle: json['department_title'],
    );
  }
}

class SupportLastMessageDto {
  final String? body;
  final String? type;
  final String? created;

  const SupportLastMessageDto({
    this.body,
    this.type,
    this.created,
  });

  factory SupportLastMessageDto.fromMap(final Map<String, dynamic> json) {
    return SupportLastMessageDto(
      body: json['body'],
      type: json['type'],
      created: json['created'],
    );
  }
}
