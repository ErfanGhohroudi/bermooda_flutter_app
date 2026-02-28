import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../models/support_department_dto.dart';

class SupportDepartmentDatasource {
  final ApiClient _apiClient = Get.find();

  void getDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final Function(GenericResponse<SupportDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SupportManager/DepartmentManager/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportDepartmentReadDto>.fromJson(
          response.data,
          fromMap: SupportDepartmentReadDto.fromMap,
        ));
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
    required final int? avatarId,
    required final Function(GenericResponse<SupportDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/SupportManager/DepartmentManager/",
        data: {
          "title": title,
          "member_id_list": members.map((final e) => e.id).toList(),
          if (avatarId != null) "avatar_id": avatarId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportDepartmentReadDto>.fromJson(
          response.data,
          fromMap: SupportDepartmentReadDto.fromMap,
        ));
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
    required final int? avatarId,
    required final Function(GenericResponse<SupportDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/SupportManager/DepartmentManager/$id/",
        data: {
          "title": title,
          "member_id_list": members.map((final e) => e.id).toList(),
          if (avatarId != null) "avatar_id": avatarId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportDepartmentReadDto>.fromJson(
          response.data,
          fromMap: SupportDepartmentReadDto.fromMap,
        ));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void archiveDepartment({
    required final int id,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.delete(
        "/v1/SupportManager/DepartmentManager/$id/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<dynamic>.fromJson(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void getArchivedDepartments({
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final Function(GenericResponse<SupportDepartmentReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SupportManager/Department/Archives/",
        queryParameters: {
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportDepartmentReadDto>.fromJson(
          response.data,
          fromMap: SupportDepartmentReadDto.fromMap,
        ));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void restoreDepartment({
    required final int id,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/SupportManager/Department/$id/restore/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<dynamic>.fromJson(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
