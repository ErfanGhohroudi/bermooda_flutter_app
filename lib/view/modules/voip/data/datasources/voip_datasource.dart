import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/loading/loading.dart';
import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../../domain/enums/enums.dart';
import '../models/response/sms_panel_number.dart';

class VoipDatasource {
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
    required final Function() onResponse,
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
          // "scheduled_at": null,
        },
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
}
