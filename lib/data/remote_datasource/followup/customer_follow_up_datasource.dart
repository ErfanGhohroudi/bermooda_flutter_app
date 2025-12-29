part of '../../data.dart';

class CustomerFollowUpDatasource implements IFollowUpDatasource {
  final ApiClient _apiClient = Get.find();

  @override
  void create({
    required final int? sourceId,
    required final String date,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmTracking/TrackingManager/Create/",
        data: {
          "customer_id": sourceId,
          "date_to_tracking": date,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  @override
  void update({
    required final String? slug,
    required final String? date,
    required final String? trackerId,
    required final List<MainFileReadDto> files,
    final String? time,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/CrmTracking/TrackingManager/$slug/",
        data: {
          "date_to_tracking": date, // required
          "tracker_id": trackerId, // required
          "file_id_list": files.map((final e) => e.fileId!).toList(),
          "time_to_tracking": time,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  @override
  void delete({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/CrmTracking/TrackingManager/$slug/",
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

  void getMyFollowups({
    required final String categoryId,
    required final int pageNumber,
    required final FollowUpFilterType filter,
    required final String? query,
    final int perPageCount = 20,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmTracking/TrackingManager/QueryData/",
        queryParameters: {
          "group_crm_id": categoryId,
          "page_number": pageNumber,
          "per_age_count": perPageCount,
          "only_mine": true,
          "is_tracked": filter == FollowUpFilterType.is_done,
          if (query != null && query.isNotEmpty) "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  @override
  void changeTimerStatus({
    required final String? slug,
    required final TimerStatusCommand? command,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CrmTracking/TrackingTimerManager/$slug/",
        data: {"command": command?.name},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  @override
  void changeStatus({
    required final String? slug,
    required final bool isSuccessFull,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/CrmTracking/TrackingManager/$slug/IsSuccessFull/",
        data: {"is_success_full": isSuccessFull},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  @override
  void restore({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/CrmTracking/TrackingManager/$slug/RestoreATracking/",
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

  @override
  void getFollowups({
    required final int? sourceId,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/CrmTracking/TrackingManager/",
        queryParameters: {"customer_id": sourceId, "is_tracked": "False"},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<FollowUpReadDto>.fromJson(response.data, fromMap: FollowUpReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
