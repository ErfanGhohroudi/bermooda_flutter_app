part of '../../../data.dart';

class CalendarReadDto {
  CalendarReadDto({
    this.date,
    this.count,
  });

  String? date;
  int? count;

  factory CalendarReadDto.fromJson(final String str) => CalendarReadDto.fromMap(json.decode(str));

  factory CalendarReadDto.fromMap(final Map<String, dynamic> json) => CalendarReadDto(
        date: json["date"].toString(),
        count: json["count"],
      );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
        "date": date,
        "count": count,
      };
}
