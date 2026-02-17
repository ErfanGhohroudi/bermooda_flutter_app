import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/loading/loading.dart';
import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../models/response/voip_department.dart';

class VoipDepartmentsDatasource {
  final ApiClient _apiClient = Get.find();

  void getDepartments({
    required final int pageNumber,
    final String? search,
    final int perPageCount = 20,
    required final Function(GenericResponse<VoipDepartmentReadDto> errorResponse) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/VoIP/departments/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipDepartmentReadDto>.fromJson(response.data, fromMap: VoipDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getArchivedDepartments({
    required final int pageNumber,
    final String? search,
    final int perPageCount = 20,
    required final Function(GenericResponse<VoipDepartmentReadDto> errorResponse) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/VoIP/departments/Archives/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipDepartmentReadDto>.fromJson(response.data, fromMap: VoipDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createDepartment({
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
    required final Function(GenericResponse<VoipDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/VoIP/departments/",
        data: {
          if (avatar?.fileId != null) "avatar_id": avatar?.fileId,
          "title": title,
          "member_ids": members.map((final m) => m.id).whereType<String>().toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipDepartmentReadDto>.fromJson(response.data, fromMap: VoipDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateDepartment({
    required final int id,
    required final String title,
    required final List<UserReadDto> members,
    final MainFileReadDto? avatar,
    required final Function(GenericResponse<VoipDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/VoIP/departments/$id/",
        data: {
          if (avatar?.fileId != null) "avatar_id": avatar?.fileId,
          "title": title,
          "member_ids": members.map((final m) => m.id).toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<VoipDepartmentReadDto>.fromJson(response.data, fromMap: VoipDepartmentReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void archiveDepartment({
    required final int id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/VoIP/departments/$id/",
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

  void restoreDepartment({
    required final int id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/VoIP/departments/$id/Restore/",
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
