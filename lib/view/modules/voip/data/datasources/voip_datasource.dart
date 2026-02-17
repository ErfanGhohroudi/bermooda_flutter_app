import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/loading/loading.dart';
import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../models/response/voip_number.dart';

class VoipDatasource {
  final ApiClient _apiClient = Get.find();

  void getNumbersByDepartment({
    required final int departmentId,
    required final int pageNumber,
    required final Function(GenericResponse<VoipNumberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/VoIP/trunks/",
        queryParameters: {
          "department_id": departmentId,
          "page_number": pageNumber,
          "per_page_count": 20,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipNumberReadDto>.fromJson(response.data, fromMap: VoipNumberReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getNumbersWithUserAccess({
    required final Function(GenericResponse<VoipNumberReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/VoIP/trunks/get-access-phone-numbers/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipNumberReadDto>.fromJson(response.data, fromMap: VoipNumberReadDto.fromMap));
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
    required final String name,
    // required final ProviderType providerType,
    required final String serviceId,
    required final String webserviceToken,
    required final Function(VoipNumberReadDto response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/VoIP/providers/",
        data: {
          "department_id": departmentId,
          "phone_number": number,
          "name": name,
          // "provider_type": providerType.name,
          "service_id": serviceId,
          "webservice_token": webserviceToken,
          //
          "base_url": "https://panel.telefonchy.com/webservice/v1",
          "events_hook_url": "https://your-domain.com/v1/VoIP/webhooks/event/",
          "cdr_hook_url": "https://your-domain.com/v1/VoIP/webhooks/cdr/",
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final res = GenericResponse<VoipNumberReadDto>.fromJson(response.data, fromMap: VoipNumberReadDto.fromMap);
        if (res.result == null) onError(res);
        if (res.result != null) {
          onResponse(res.result!);
        }
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
        "/v1/VoIP/trunks/$id/",
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
