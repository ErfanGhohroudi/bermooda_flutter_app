part of '../../../../data.dart';

class ReportFollowupArchiveReadDto extends IReportArchiveReadDto {
  const ReportFollowupArchiveReadDto({
    super.id,
    super.type,
    super.creator,
    super.body,
    super.date,
    super.persianDateTimeString,
    super.isArchived,
    this.files = const [],
    this.followup,
  });

  final List<MainFileReadDto> files;
  final FollowUpReadDto? followup;

  factory ReportFollowupArchiveReadDto.fromJson(final String str) => ReportFollowupArchiveReadDto.fromMap(json.decode(str));

  factory ReportFollowupArchiveReadDto.fromMap(final Map<String, dynamic> json) {
    final type = ReportType.fromString(json["message_type"] ?? json["report_type"]);

    final String? time = json["created_at_persian"]?.trim();

    return ReportFollowupArchiveReadDto(
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
      files: json["file"] == null ? [] : List<MainFileReadDto>.from(json["file"]!.map((final x) => MainFileReadDto.fromMap(x))),
      followup: (json["related_object"] ?? json["relation_object"])?["data"] == null
          ? null
          : FollowUpReadDto.fromMap((json["related_object"] ?? json["relation_object"])["data"]),
      isArchived: json["is_archived"] ?? json["is_archive"] ?? false,
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
    followup,
    isArchived,
  ];
}
