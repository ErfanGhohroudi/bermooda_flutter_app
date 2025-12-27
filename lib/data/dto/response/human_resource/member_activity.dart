part of '../../../data.dart';

class MemberActivityReadDto extends Equatable {
  const MemberActivityReadDto({
    this.id,
    this.startDate,
    this.endDate,
    this.elapsedSeconds = 0,
    this.status,
  });

  final int? id;
  final Jalali? startDate;
  final Jalali? endDate;
  final int elapsedSeconds;
  final MemberActivityType? status;

  MemberActivityReadDto copyWith({
    final int? id,
    final Jalali? startDate,
    final Jalali? endDate,
    final int? elapsedSeconds,
    final MemberActivityType? status,
  }) =>
      MemberActivityReadDto(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        status: status ?? this.status,
      );

  factory MemberActivityReadDto.fromJson(final String str) => MemberActivityReadDto.fromMap(json.decode(str));

  factory MemberActivityReadDto.fromMap(final Map<String, dynamic> json) {
    Jalali? getJalali(final String? raw) {
      // raw = "1403/2/1 14:21"
      if (raw == null) {
        return null;
      }

      final datePart = raw.split(" ").firstOrNull;
      final timePart = raw.split(" ").lastOrNull;

      // final List<String> dateParts = datePart.split('/');
      final List<String>? timeParts = timePart?.split(':');

      return datePart.toJalali()?.copyWith(
            hour: int.tryParse(timeParts?[0].numericOnly() ?? '0'),
            minute: int.tryParse(timeParts?[1].numericOnly() ?? '0'),
          );
      // return dateParts.length == 3 && timeParts.length >= 2
      //     ? Jalali(
      //         int.parse(dateParts[0].numericOnly()), //year
      //         int.parse(dateParts[1].numericOnly()), //month
      //         int.parse(dateParts[2].numericOnly()), //day
      //         int.parse(timeParts[0].numericOnly()), //hour
      //         int.parse(timeParts[1].numericOnly()), //minute
      //       )
      //     : null;
    }

    return MemberActivityReadDto(
      id: json["id"],
      startDate: getJalali(json["start_time_jalali"]),
      endDate: getJalali(json["end_date_time_jalali"]),
      elapsedSeconds: json["get_elapsed_seconds"] ?? 0,
      status: json["status"] == null ? null : MemberActivityType.values.firstWhereOrNull((final type) => type.name == json["status"]),
    );
  }

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        elapsedSeconds,
        status,
      ];
}
