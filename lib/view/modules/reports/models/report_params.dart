import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import '../create/forms/enum/enums.dart';

abstract class IReportParams extends Equatable {
  const IReportParams();

  Map<String, dynamic> toMap();

  ReportFormType get type;

  @override
  List<Object?> get props => [];
}

/// Note
class ReportNoteParams extends IReportParams {
  final ReportFormType _formType;
  final String noteText;

  const ReportNoteParams({required this.noteText}) : _formType = ReportFormType.Note;

  @override
  Map<String, dynamic> toMap() => {
    "report_type": _formType.name.toLowerCase(),
    "body": noteText,
  };

  @override
  ReportFormType get type => _formType;

  @override
  List<Object?> get props => [
    _formType,
    noteText,
  ];
}

/// Invoice
class ReportInvoiceParams extends IReportParams {
  final ReportFormType _formType;
  final String amount;
  final InvoiceType invoiceType;
  final InvoiceStatusType invoiceStatusType;
  final List<Jalali> remindDates;
  final String? invoiceId;
  final List<LabelReadDto> labels;
  final List<MainFileReadDto> files;

  const ReportInvoiceParams({
    required this.amount,
    required this.invoiceType,
    required this.invoiceStatusType,
    required this.remindDates,
    this.invoiceId,
    this.labels = const [],
    this.files = const [],
  }) : _formType = ReportFormType.Factor;

  @override
  Map<String, dynamic> toMap() => {
    "report_type": _formType.name.toLowerCase(),
    "factor_type": invoiceType.name,
    "sub_factor_type": invoiceStatusType.name,
    "amount": amount.toInt(),
    "factor_code": invoiceId,
    "reminder_date_list": remindDates.map((final date) => date.formatCompactDate()).toList(),
    "label_slug_list": labels.map((final e) => e.slug).whereType<String>().toList(),
    "attached_file_id_list": files.map((final e) => e.fileId).whereType<int>().toList(),
  };

  @override
  ReportFormType get type => _formType;

  @override
  List<Object?> get props => [
    _formType,
    invoiceType,
    invoiceStatusType,
    amount,
    invoiceId,
    remindDates.map((final date) => date.formatCompactDate()).toList(),
    labels.map((final e) => e.slug).whereType<String>().toList(),
    files.map((final e) => e.fileId).whereType<int>().toList(),
  ];
}

/// Contract
class ReportContractParams extends IReportParams {
  final ReportFormType _formType;
  final String title;
  final LabelReadDto? contractType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? amount;
  final List<MainFileReadDto> files;

  const ReportContractParams({
    required this.title,
    this.contractType,
    this.startDate,
    this.endDate,
    this.amount,
    this.files = const [],
  }) : _formType = ReportFormType.contract;

  @override
  Map<String, dynamic> toMap() => {
    "report_type": _formType.name.toLowerCase(),
    "title": title,
    "contract_type_slug": contractType?.slug,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "amount": amount?.toInt(),
    "attached_file_id_list": files.map((final e) => e.fileId).whereType<int>().toList(),
  };

  @override
  ReportFormType get type => _formType;

  @override
  List<Object?> get props => [
    _formType,
    title,
    contractType?.slug,
    startDate?.toIso8601String(),
    endDate?.toIso8601String(),
    amount,
    files.map((final e) => e.fileId).whereType<int>().toList(),
  ];
}
