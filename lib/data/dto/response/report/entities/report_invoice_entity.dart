part of '../../../../data.dart';

class InvoiceEntity extends Equatable {
  const InvoiceEntity({
    this.slug,
    this.type,
    this.status,
    this.task,
    this.amount,
    // this.currency,
    this.invoiceId,
    this.reminders = const [],
    this.labels = const [],
    this.files = const [],
  });

  final String? slug;
  final InvoiceType? type;
  final InvoiceStatusType? status;
  final TaskReadDto? task;
  final String? amount;
  // final CurrencyUnitReadDto? currency;
  final String? invoiceId;
  final List<String> reminders;
  final List<LabelReadDto> labels;
  final List<MainFileReadDto> files;

  factory InvoiceEntity.fromJson(final String str) => InvoiceEntity.fromMap(json.decode(str));

  factory InvoiceEntity.fromMap(final Map<String, dynamic> json) => InvoiceEntity(
    slug: json["slug"],
    type: json["factor_type"] == null ? null : InvoiceType.values.firstWhereOrNull((final e) => e.name == json["factor_type"]),
    status: json["sub_factor_type"] == null ? null : InvoiceStatusType.values.firstWhereOrNull((final e) => e.name == json["sub_factor_type"]),
    task: json["task"] == null ? null : TaskReadDto.fromMap(json["task"]),
    amount: json["amount"]?.toString(),
    // currency: json["currency"] == null ? null : CurrencyUnitReadDto.fromMap(json["currency"]),
    invoiceId: json["factor_code"],
    reminders: (json["reminders"] ?? []).cast<String>(),
    labels: json["label_slug_list"] == null ? [] : List<LabelReadDto>.from(json["label_slug_list"].map((final x) => LabelReadDto.fromMap(x))),
    files: json["attached_file"] == null ? [] : List<MainFileReadDto>.from(json["attached_file"].map((final x) => MainFileReadDto.fromMap(x))),
  );

  @override
  List<Object?> get props => [
    slug,
    type,
    status,
    amount,
    // currency,
    invoiceId,
    files,
  ];
}