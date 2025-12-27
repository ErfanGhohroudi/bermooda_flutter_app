part of '../../../data.dart';

class ExelUploadResultReadDto extends Equatable {
  const ExelUploadResultReadDto({
    this.tempFileId,
    this.totalRows = 0,
    this.hasDuplicates = false,
    this.duplicateCount = 0,
    this.columns = const [],
    this.previewData = const [],
  });

  final String? tempFileId;
  final int totalRows;
  final bool hasDuplicates;
  final int duplicateCount;
  final List<ExelColumn> columns;
  final List<Map<String, dynamic>> previewData;

  factory ExelUploadResultReadDto.fromJson(final String str) => ExelUploadResultReadDto.fromMap(json.decode(str));

  factory ExelUploadResultReadDto.fromMap(final dynamic json) => ExelUploadResultReadDto(
        tempFileId: json["temp_file_id"],
        totalRows: json["total_rows"] ?? 0,
        hasDuplicates: json["has_duplicates"] ?? false,
        duplicateCount: json["duplicate_count"] ?? 0,
        columns: json["columns"] == null ? [] : List<ExelColumn>.from(json["columns"].map((final x) => ExelColumn.fromMap(x))),
        previewData: json["preview_data"] == null ? [] : List<Map<String, dynamic>>.from(json["preview_data"]),
      );

  @override
  List<Object?> get props => [
        tempFileId,
        totalRows,
        hasDuplicates,
        duplicateCount,
        columns,
      ];
}

class ExelColumn extends Equatable {
  const ExelColumn({
    this.originalColumn,
    this.detectedField,
    this.confidence = 0,
    this.method,
    this.sampleData = const [],
  });

  final String? originalColumn;
  final String? detectedField;
  final int confidence;
  final String? method;
  final List<String> sampleData;

  ExelColumn copyWith({
    final String? originalColumn,
    final String? detectedField,
    final int? confidence,
    final String? method,
    final List<String>? sampleData,
  }) {
    return ExelColumn(
      originalColumn: originalColumn ?? this.originalColumn,
      detectedField: detectedField ?? this.detectedField,
      confidence: confidence ?? this.confidence,
      method: method ?? this.method,
      sampleData: sampleData ?? this.sampleData,
    );
  }

  ExelColumn copyWithDetectedField(final String? detectedField) {
    return ExelColumn(
      originalColumn: originalColumn,
      detectedField: detectedField,
      confidence: confidence,
      method: method,
      sampleData: sampleData,
    );
  }

  factory ExelColumn.fromJson(final String str) => ExelColumn.fromMap(json.decode(str));

  factory ExelColumn.fromMap(final dynamic json) => ExelColumn(
        originalColumn: json["original_column"],
        detectedField: json["detected_field"],
        confidence: ((json["confidence"] ?? 0).toDouble() * 100).round(),
        method: json["method"],
        sampleData: json["sample_data"] == null ? [] : List<String>.from(json["sample_data"]),
      );

  Map<String, dynamic> toMap() => {
    "original_column": originalColumn,
    "user_selected_field": detectedField ?? 'ignore',
  };

  @override
  List<Object?> get props => [
        originalColumn,
        detectedField,
        confidence,
        method,
        sampleData,
      ];
}
