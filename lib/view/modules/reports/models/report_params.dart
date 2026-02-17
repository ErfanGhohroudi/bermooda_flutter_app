import 'package:equatable/equatable.dart';
import 'package:u/utilities.dart';

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
