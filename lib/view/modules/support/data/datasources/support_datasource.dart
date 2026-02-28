import 'package:dio/dio.dart' as dio;
import 'package:u/utilities.dart';

import '../../../../../data/api_client.dart';
import '../../../../../data/data.dart';
import '../models/support_room_dto.dart';

class SupportDatasource {
  final ApiClient _apiClient = Get.find();

  void getMyAssignedRooms({
    required final int departmentId,
    required final int pageNumber,
    required final int perPageCount,
    required final String? search,
    required final Function(GenericResponse<SupportRoomReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SupportManager/CustomerRoomManager/MyRooms/",
        queryParameters: {
          "department_id": departmentId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportRoomReadDto>.fromJson(response.data, fromMap: SupportRoomReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void transferRoomToAnotherOperator({
    required final int roomId,
    required final int operatorId,
    required final String? note,
    required final Function(GenericResponse<SupportRoomReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/SupportManager/Ticket/$roomId/transfer/",
        queryParameters: {
          "operator_id": operatorId,
          if (note != null && note.isNotEmpty) "note": note,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SupportRoomReadDto>.fromJson(response.data, fromMap: SupportRoomReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
