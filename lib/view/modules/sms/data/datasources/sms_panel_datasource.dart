import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/loading/loading.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../../domain/enums/enums.dart';
import '../models/response/group_sms_dto.dart';
import '../models/response/received_sms_dto.dart';
import '../models/response/sms_dto.dart';
import '../models/response/sms_panel_number_dto.dart';
import '../models/response/validation_numbers_result_dto.dart';

class SmsPanelDatasource {
  final ApiClient _apiClient = Get.find();

  void getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
    required final Function(GenericResponse<SmsPanelNumberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SMSManager/phone-numbers/",
        queryParameters: {
          "department_id": departmentId,
          "page_number": pageNumber,
          "per_page_count": 20,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SmsPanelNumberReadDto>.fromJson(response.data, fromMap: SmsPanelNumberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getNumbersWithUserAccess({
    required final Function(GenericResponse<SmsPanelNumberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SMSManager/phone-numbers/get-access-phone-numbers/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SmsPanelNumberReadDto>.fromJson(response.data, fromMap: SmsPanelNumberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createNumber({
    required final int departmentId,
    required final String number,
    required final String providerName,
    required final ProviderType providerType,
    required final String apiKey,
    required final Function(SmsPanelNumberReadDto response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/phone-numbers/",
        data: {
          "department_id": departmentId,
          "number": number,
          "provider_name": providerName,
          "provider_type": providerType.name,
          "api_key": apiKey,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(SmsPanelNumberReadDto.fromMap(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void deleteNumber({
    required final int id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/SMSManager/phone-numbers/$id/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void sendSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
    required final Function(GenericResponse<SmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/messages/send_sms/",
        data: {
          "sender": senderId,
          "recipient": recipient,
          "content": content,
          if (departmentId != null) "department": departmentId,
          if (scheduledAt != null) "scheduled_at": scheduledAt.toUtcDateTime().toIso8601String(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: SmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Either [recipients] or [fileId] must be provided
  void sendGroupSMS({
    required final String title,
    required final String content,
    required final List<String>? recipients,
    required final int? fileId,
    required final int senderId,
    final int? departmentId,
    final Jalali? scheduledAt,
    required final Function(GenericResponse<GroupSmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/send_bulk_sms/",
        data: {
          "title": title,
          "sender": senderId,
          if (recipients != null) "recipients": recipients,
          if (fileId != null) "file_id": fileId,
          "content": content,
          if (departmentId != null) "department": departmentId,
          if (scheduledAt != null) "scheduled_at": scheduledAt.toUtcDateTime().toIso8601String(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: GroupSmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void sendTestSMS({
    required final String content,
    required final String recipient,
    required final int senderId,
    required final Function(GenericResponse<SmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/test_send/",
        data: {
          "sender": senderId,
          "recipient": recipient,
          "content": content,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: SmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void cancelSMS({
    required final int id,
    required final Function(GenericResponse<SmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/$id/cancel_send_message/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: SmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void cancelGroupSMS({
    required final int id,
    required final Function(GenericResponse<GroupSmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/$id/cancel_bulk_message/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: GroupSmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final SMSStatus? status,
    required final Function(GenericResponse<SmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SMSManager/messages/",
        queryParameters: {
          "department_id": departmentId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
          if (status != null) "status": status,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: SmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getGroupSmsList({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final GroupSMSStatus? status,
    required final Function(GenericResponse<GroupSmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SMSManager/bulk-messages/",
        queryParameters: {
          "department_id": departmentId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
          if (status != null) "status": status,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: GroupSmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getReceivedMessages({
    required final int departmentId,
    final int? phoneId,
    final int? pageNumber,
    final int? perPageCount,
    final String? search,
    final Jalali? startDate,
    final Jalali? endDate,
    final bool isExport = false,
    required final Function(GenericResponse<ReceivedSmsReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SMSManager/received-messages/",
        queryParameters: {
          "department_id": departmentId,
          if (phoneId != null) "phone_id": phoneId,
          if (pageNumber != null) "page_number": pageNumber,
          if (perPageCount != null) "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
          if (startDate != null) "start_date": startDate.toDateTime().toCompactIso8601,
          if (endDate != null) "end_date": endDate.toDateTime().toCompactIso8601,
          "is_export": isExport ? 1 : 0,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: ReceivedSmsReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void validatePhoneNumberList({
    required final List<String> numbers,
    required final Function(GenericResponse<ValidationNumbersResultReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/validate_recipients/",
        data: {"recipients": numbers},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: ValidationNumbersResultReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void validateFilePhoneNumberList({
    required final int fileId,
    required final Function(GenericResponse<ValidationNumbersResultReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/SMSManager/bulk-messages/validate_bulk_file/",
        data: {"file_id": fileId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse.fromJson(response.data, fromMap: ValidationNumbersResultReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
