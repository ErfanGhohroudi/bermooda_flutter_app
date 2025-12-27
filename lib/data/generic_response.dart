part of 'data.dart';

class GenericResponse<T> {
  GenericResponse({
    this.result,
    this.resultList,
    this.status,
    this.message = "",
    this.extra,
  });

  final bool? status;
  final String message;
  final T? result;
  final List<T>? resultList;
  final ExtraReadDto? extra;

  factory GenericResponse.fromJson(final dynamic json, {final Function? fromMap}) {
    if (json == null || json is! Map<String, dynamic>) {
      return GenericResponse<T>(
        status: false,
        message: "پاسخ نامعتبر یا خالی از سرور دریافت شد.",
      );
    }

    final status = json["status"] == null
        ? null
        : json["status"] == true
            ? true
            : json["status"].toString().toLowerCase() == 'false'
                ? false
                : false;

    if (fromMap == null) return GenericResponse<T>(status: status, message: json["message"].toString());
    if (json["data"] is List) {
      return GenericResponse<T>(
        resultList: List<T>.from(json['data'].cast<Map<String, dynamic>>().map(fromMap)),
        status: status,
        message: json["message"].toString(),
        extra: (json["extra"] ?? json["pagination"]) == null ? null : ExtraReadDto.fromJson(json["extra"] ?? json["pagination"]),
      );
    }
    if (json["data"] is String) {
      return GenericResponse<T>(
        result: json["data"],
        status: status,
        message: json["message"].toString(),
        extra: json["extra"] ?? json["pagination"],
      );
    }
    return GenericResponse<T>(
      result: json["data"] != null ? fromMap(json["data"]) : '',
      status: status,
      message: json["message"].toString(),
      extra: (json["extra"] ?? json["pagination"]) == null ? null : ExtraReadDto.fromJson(json["extra"] ?? json["pagination"]),
    );
  }
}

class ExtraReadDto {
  final int? count;
  final int? next;
  final int? previous;

  ExtraReadDto({
    this.count,
    this.next,
    this.previous,
  });

  factory ExtraReadDto.fromJson(final dynamic json) {
    return ExtraReadDto(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
    );
  }
}
