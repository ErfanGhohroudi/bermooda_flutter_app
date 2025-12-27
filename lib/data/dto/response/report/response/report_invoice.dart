part of '../../../../data.dart';

class ReportInvoiceReadDto extends BaseHistoryReadDto {
  const ReportInvoiceReadDto({
    super.id,
    super.type,
    super.creator,
    super.body,
    super.date,
    super.persianDateTimeString,
    this.files = const [],
    this.invoice,
  });

  final List<MainFileReadDto> files;
  final InvoiceEntity? invoice;

  factory ReportInvoiceReadDto.fromJson(final String str) => ReportInvoiceReadDto.fromMap(json.decode(str));

  factory ReportInvoiceReadDto.fromMap(final Map<String, dynamic> json) {
    final type = ReportType.fromString(json["message_type"] ?? json["report_type"]);

    final String? time = json["created_at_persian"]?.trim();

    InvoiceEntity? getRelatedObject(final Map<String, dynamic>? json) {
      if (json == null) return null;
      final String? dataType = json['data_type'];

      final Map<String, dynamic> data = json['data'];

      switch (dataType) {
        case "task_factor_data":
          return InvoiceEntity.fromMap(data);
        // case "customer_factor_data":
        case "factor_data":
          return InvoiceEntity.fromMap(data);
        default:
          return null;
      }
    }

    return ReportInvoiceReadDto(
      id: json["id"],
      type: type,
      creator: json["creator"] == null ? null : UserReadDto.fromMap(json["creator"]),
      files: json["file"] == null ? [] : List<MainFileReadDto>.from(json["file"]!.map((final x) => MainFileReadDto.fromMap(x))),
      body: json["body"],
      date: json["created_at_date_persian"] != null
          ? json["created_at_date_persian"]?.toString().trim().toJalali()
          : json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]?.toString().trim() ?? "")?.toJalali()
          : null,
      invoice: getRelatedObject(json["related_object"] ?? json["relation_object"]),
      persianDateTimeString: time,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        creator,
        files,
        body,
        date,
        invoice,
        persianDateTimeString,
      ];
}
