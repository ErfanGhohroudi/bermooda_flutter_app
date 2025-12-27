part of '../../../data.dart';

class EventsReadDto {
  EventsReadDto({
    required this.checklists,
    required this.customers,
    required this.meetings,
  });

  List<SubtaskReadDto>? checklists;
  List<CustomerReadDto>? customers;
  List<MeetingReadDto>? meetings;

  factory EventsReadDto.fromJson(final String str) => EventsReadDto.fromMap(json.decode(str));

  factory EventsReadDto.fromMap(final Map<String, dynamic> json) => EventsReadDto(
    checklists: json["task_list"] == null ? [] : List<SubtaskReadDto>.from(json["task_list"]!.map((final x) => SubtaskReadDto.fromMap(x))),
    customers: json["customer_list"] == null ? [] : List<CustomerReadDto>.from(json["customer_list"]!.map((final x) => CustomerReadDto.fromMap(x))),
    meetings: json["schedule_occurrences"] == null ? [] : List<MeetingReadDto>.from(json["schedule_occurrences"]!.map((final x) => MeetingReadDto.fromMap(x))),
  );
}
