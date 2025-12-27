part of '../data.dart';

class NotificationDataSource {
  final ApiClient _apiClient = Get.find();

  void getNotifications({
    required final String workspaceId,
    required final int pageNumber,
    final int perPageCount = 20,
    required final Function(GenericResponse<INotificationReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/Notification/MainNotificationManager/",
        queryParameters: {
          "workspace_id": workspaceId,
          "page_number": pageNumber,
          "per_page_count": perPageCount
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<INotificationReadDto>.fromJson(response.data, fromMap: INotificationReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }
}
