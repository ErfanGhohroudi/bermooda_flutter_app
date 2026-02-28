import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../models/support_customer_dto.dart';
import '../models/support_section_dto.dart';

class SupportBoardDatasource {
  final ApiClient _apiClient = Get.find();

  void createCustomer({
    required final int departmentId,
    required final int sectionId,
    required final String fullName,
    required final String phoneNumber,
    required final Function(GenericResponse<SupportCustomerReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/SupportManager/DepartmentManager/$departmentId/tickets/",
        data: {
          "fullname": fullName,
          "phone_number": phoneNumber,
          "label_id": sectionId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportCustomerReadDto>.fromJson(response.data, fromMap: SupportCustomerReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createSection({
    required final int departmentId,
    required final String title,
    required final LabelColors color,
    required final Function(GenericResponse<SupportSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/SupportManager/DepartmentManager/$departmentId/labels/",
        data: {
          "title": title,
          "color_code": color.colorCode,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportSectionReadDto>.fromJson(response.data, fromMap: SupportSectionReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateSection({
    required final int id,
    required final String title,
    required final LabelColors color,
    required final Function(GenericResponse<SupportSectionReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/SupportManager/Label/$id/",
        data: {
          "title": title,
          "color_code": color.colorCode,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          GenericResponse<SupportSectionReadDto>.fromJson(response.data, fromMap: SupportSectionReadDto.fromMap),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void deleteSection({
    required final int id,
    required final Function(GenericResponse<dynamic> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.delete(
        "/v1/SupportManager/Label/$id/",
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
