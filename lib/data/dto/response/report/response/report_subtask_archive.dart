part of '../../../../data.dart';

class ReportSubtaskArchiveReadDto extends IReportArchiveReadDto {
  const ReportSubtaskArchiveReadDto({
    super.id,
    super.type,
    super.creator,
    super.body,
    super.date,
    super.persianDateTimeString,
    super.isArchived,
    this.files = const [],
    this.subtask,
  });

  final List<MainFileReadDto> files;
  final SubtaskReadDto? subtask;

  factory ReportSubtaskArchiveReadDto.fromJson(final String str) => ReportSubtaskArchiveReadDto.fromMap(json.decode(str));

  factory ReportSubtaskArchiveReadDto.fromMap(final Map<String, dynamic> json) {
    final type = ReportType.fromString(json["message_type"] ?? json["report_type"]);

    final String? time = json["created_at_persian"]?.trim();

    return ReportSubtaskArchiveReadDto(
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
      isArchived: json["is_archived"] ?? false,
      files: json["file"] == null ? [] : List<MainFileReadDto>.from(json["file"]!.map((final x) => MainFileReadDto.fromMap(x))),
      subtask: (json["related_object"] ?? json["relation_object"])?["data"] == null
          ? null
          : SubtaskReadDto.fromMap((json["related_object"] ?? json["relation_object"])["data"]),
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
        isArchived,
        files,
        subtask,
      ];
}
