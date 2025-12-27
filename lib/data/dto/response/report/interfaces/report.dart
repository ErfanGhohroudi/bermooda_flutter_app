part of '../../../../data.dart';

abstract class IReportReadDto {
  int? get id;

  ReportType? get type;

  UserReadDto? get creator;

  String? get body;

  Jalali? get date;

  String? get persianDateTimeString;

  bool get isArchived;

  factory IReportReadDto.fromJson(final String str) => IReportReadDto.fromMap(json.decode(str));

  factory IReportReadDto.fromMap(final Map<String, dynamic> json) {
    final dataType = ReportType.fromString(json["message_type"] ?? json["report_type"]);

    switch (dataType) {
      case ReportType.update:
        return ReportUpdateReadDto.fromMap(json);
      case ReportType.archive:
        return IReportArchiveReadDto.fromMap(json);
      case ReportType.note:
        return ReportNoteReadDto.fromMap(json);
      // case ReportType.invoice:
      //   return ReportInvoiceReadDto.fromMap(json);
      // case ReportType.contract:
      //   return ReportContractReadDto.fromMap(json);
      default:
        return const BaseHistoryReadDto();
    }
  }
}

class BaseHistoryReadDto extends Equatable implements IReportReadDto {
  const BaseHistoryReadDto({
    this.id,
    this.type,
    this.creator,
    this.body,
    this.date,
    this.persianDateTimeString,
    this.isArchived = false,
  });

  @override
  final int? id;

  @override
  final ReportType? type;

  @override
  final UserReadDto? creator;

  @override
  final String? body;

  @override
  final Jalali? date;

  @override
  final String? persianDateTimeString;

  @override
  final bool isArchived;

  @override
  List<Object?> get props => [];
}
