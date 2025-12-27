part of '../../../../data.dart';

class IReportArchiveReadDto extends BaseHistoryReadDto {
  const IReportArchiveReadDto({
    super.id,
    super.type,
    super.creator,
    super.body,
    super.date,
    super.persianDateTimeString,
    super.isArchived,
  });

  factory IReportArchiveReadDto.fromJson(final String str) => IReportArchiveReadDto.fromMap(json.decode(str));

  factory IReportArchiveReadDto.fromMap(final Map<String, dynamic> json) {
    final String? dataType = (json["related_object"] ?? json["relation_object"])?['data_type'];

    switch (dataType) {
      case "check_list_data" || "contract_checklist":
        return ReportSubtaskArchiveReadDto.fromMap(json);
      case "tracking_data" || "contract_tracking":
        return ReportFollowupArchiveReadDto.fromMap(json);
      default:
        return const IReportArchiveReadDto();
    }
  }

  @override
  List<Object?> get props => [];
}
