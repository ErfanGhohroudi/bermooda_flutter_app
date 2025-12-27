part of '../../../data.dart';

class ExelResultReadDto extends Equatable {
  const ExelResultReadDto({
    this.totalRows = 0,
    this.successfulImports = 0,
    this.failedImports = 0,
    this.duplicatesFound = 0,
    this.duplicatesMerged = 0,
    this.documentId,
    this.errors = const [],
  });

  final int totalRows;
  final int successfulImports;
  final int failedImports;
  final int duplicatesFound;
  final int duplicatesMerged;
  final int? documentId;
  final List<RowError> errors;

  factory ExelResultReadDto.fromJson(final String str) => ExelResultReadDto.fromMap(json.decode(str));

  factory ExelResultReadDto.fromMap(final dynamic json) =>
      ExelResultReadDto(
        totalRows: json["total_rows"] ?? 0,
        successfulImports: json["successful_imports"] ?? 0,
        failedImports: json["failed_imports"] ?? 0,
        duplicatesFound: json["duplicates_found"] ?? 0,
        duplicatesMerged: json["duplicates_merged"] ?? 0,
        documentId: json["document_id"],
        errors: json["errors"] == null ? [] : List<RowError>.from(json["errors"].map((final x) => RowError.fromMap(x))),
      );

  @override
  List<Object?> get props =>
      [
        totalRows,
        successfulImports,
        failedImports,
        duplicatesFound,
        duplicatesMerged,
        errors,
      ];
}

class RowError extends Equatable {
  const RowError({
    this.row = 0,
    this.error,
  });

  final int row;
  final String? error;

  factory RowError.fromJson(final String str) => RowError.fromMap(json.decode(str));

  factory RowError.fromMap(final dynamic json) =>
      RowError(
        row: json["row"] ?? 0,
        error: json["error"],
      );

  @override
  List<Object?> get props =>
      [
        row,
        error,
      ];
}
