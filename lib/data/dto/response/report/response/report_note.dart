part of '../../../../data.dart';

class ReportNoteReadDto extends BaseHistoryReadDto {
  const ReportNoteReadDto({
    super.id,
    super.type,
    super.creator,
    super.body,
    super.date,
    super.persianDateTimeString,
  });

  factory ReportNoteReadDto.fromJson(final String str) => ReportNoteReadDto.fromMap(json.decode(str));

  factory ReportNoteReadDto.fromMap(final Map<String, dynamic> json) {
    final type = ReportType.fromString(json["message_type"] ?? json["report_type"]);

    final String? time = json["created_at_persian"]?.trim();

    return ReportNoteReadDto(
      id: json["id"],
      type: type,
      creator: json["creator"] == null ? null : UserReadDto.fromMap(json["creator"]),
      body: json["body"],
      date: json["created_at_date_persian"] != null
          ? json["created_at_date_persian"]?.toString().trim().toJalali()
          : json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]?.toString().trim() ?? "")?.toJalali()
          : null,
      persianDateTimeString: time,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        creator,
        body,
        date,
        persianDateTimeString,
      ];
}
