part of '../../../data.dart';

class ExelMappingResultReadDto extends Equatable {
  const ExelMappingResultReadDto({
    this.preview = const [],
    this.validationSummary,
    this.errorFile,
    this.errorList = const [],
  });

  final List<ExelPreviewRow> preview;
  final ExelValidationSummary? validationSummary;
  final MainFileReadDto? errorFile;
  final List<ExelErrorData> errorList;

  factory ExelMappingResultReadDto.fromJson(final String str) => ExelMappingResultReadDto.fromMap(json.decode(str));

  factory ExelMappingResultReadDto.fromMap(final json) {
    return ExelMappingResultReadDto(
      preview: json["preview"] == null ? const [] : List<ExelPreviewRow>.from((json["preview"]).map((final x) => ExelPreviewRow.fromMap(x))),
      validationSummary: json["validation_summary"] == null ? null : ExelValidationSummary.fromMap(json["validation_summary"]),
      errorFile: json["error_file"] == null ? null : MainFileReadDto.fromMap(json["error_file"]),
      errorList: json["errors"] == null ? const [] : List<ExelErrorData>.from((json["errors"] as List<dynamic>).map((final dynamic x) => ExelErrorData.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [
        preview,
        validationSummary,
        errorFile,
        errorList,
      ];
}

class ExelPreviewRow extends Equatable {
  const ExelPreviewRow({
    this.rowNumber,
    this.data,
    this.isValid = false,
    this.validationErrors = const [],
  });

  final int? rowNumber;
  final Map<String, dynamic>? data;
  final bool isValid;
  final List<String> validationErrors;

  factory ExelPreviewRow.fromJson(final String str) => ExelPreviewRow.fromMap(json.decode(str));

  factory ExelPreviewRow.fromMap(final Map<String, dynamic> json) => ExelPreviewRow(
        rowNumber: json["row_number"]?.toInt(),
        data: json["data"] as Map<String, dynamic>?,
        isValid: json["is_valid"] ?? false,
        validationErrors: json["validation_errors"] == null ? const [] : List<String>.from(json["validation_errors"]),
      );

  @override
  List<Object?> get props => [
        rowNumber,
        data,
        isValid,
        validationErrors,
      ];
}

class ExelValidationSummary extends Equatable {
  const ExelValidationSummary({
    this.totalPreviewRows,
    this.validRows,
    this.invalidRows,
  });

  final int? totalPreviewRows;
  final int? validRows;
  final int? invalidRows;

  factory ExelValidationSummary.fromJson(final String str) => ExelValidationSummary.fromMap(json.decode(str));

  factory ExelValidationSummary.fromMap(final Map<String, dynamic> json) => ExelValidationSummary(
        totalPreviewRows: json["total_preview_rows"]?.toInt(),
        validRows: json["valid_rows"]?.toInt(),
        invalidRows: json["invalid_rows"]?.toInt(),
      );

  @override
  List<Object?> get props => [
        totalPreviewRows,
        validRows,
        invalidRows,
      ];
}

class ExelErrorData extends Equatable {
  const ExelErrorData({
    this.errors = const [],
    this.row,
  });

  final List<String> errors;
  final int? row;

  factory ExelErrorData.fromJson(final String str) => ExelErrorData.fromMap(json.decode(str));

  factory ExelErrorData.fromMap(final Map<String, dynamic> json) => ExelErrorData(
        errors: json["errors"] == null ? const [] : List<String>.from(json["errors"]),
        row: json["row"]?.toInt(),
      );

  @override
  List<Object?> get props => [
        errors,
        row,
      ];
}
