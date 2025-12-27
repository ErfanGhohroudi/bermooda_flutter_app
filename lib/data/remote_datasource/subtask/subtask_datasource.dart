part of '../../data.dart';

class SubtaskDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void create({
    required final SubtaskDataSourceType dataSourceType,
    required final SubtaskReadDto dto,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/MainCheckListManager",
        SubtaskDataSourceType.legal => '/v1/ContractBoard/ContractChecklistItem/Create/',
      };

      final response = await _apiClient.post(
        mainUrl,
        data: dto.toMap(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void update({
    required final SubtaskDataSourceType dataSourceType,
    required final String? id,
    required final SubtaskReadDto dto,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/MainCheckListManager/$id",
        SubtaskDataSourceType.legal => '/v1/ContractBoard/ContractChecklistItem/$id/',
      };

      final response = await _apiClient.put(
        mainUrl,
        data: dto.toMap(),
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void delete({
    required final SubtaskDataSourceType dataSourceType,
    required final String? id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/MainCheckListManager/$id",
        SubtaskDataSourceType.legal => '/v1/ContractBoard/ContractChecklistItem/$id/',
      };

      final response = await _apiClient.delete(
        mainUrl,
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

  void changeChecklistStatus({
    required final SubtaskDataSourceType dataSourceType,
    required final String id,
    required final bool status,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/CheckListManager/$id",
        SubtaskDataSourceType.legal => '/v1/ContractBoard/ContractChecklistItem/$id/ChangeStatus/',
      };

      final response = await _apiClient.put(
        mainUrl,
        data: {
          "command": "change check list status",
          "status": status,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Not provided for legal
  void getAllMySubtasks({
    required final SubtaskDataSourceType dataSourceType,
    required final int pageNumber,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/MyTaskCheckList",
        SubtaskDataSourceType.legal => '',
      };

      final response = await _apiClient.get(
        mainUrl,
        queryParameters: {"page_number": pageNumber, "per_age_count": 20},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Not provided for project
  void getSubtasks({
    required final SubtaskDataSourceType dataSourceType,
    required final int sourceId,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "",
        SubtaskDataSourceType.legal => "/v1/ContractBoard/ContractChecklistItem/",
      };

      final response = await _apiClient.get(
        mainUrl,
        queryParameters: {"contract_case_id": sourceId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  /// Not provided for legal
  void getMySubtasks({
    required final SubtaskDataSourceType dataSourceType,
    required final String projectId,
    required final int pageNumber,
    required final SubtaskFilter filter,
    final int perPageCount = 20,
    final String? query,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/MyTaskCheckList/$projectId",
        SubtaskDataSourceType.legal => '',
      };

      final response = await _apiClient.get(
        mainUrl,
        queryParameters: {
          "page_number": pageNumber,
          "per_age_count": perPageCount,
          "data_status": filter.name,
          if (query != null && query != '') "search": query,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void changeTimerStatus({
    required final SubtaskDataSourceType dataSourceType,
    required final int? id,
    required final TimerStatusCommand? command,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/CheckListTimerManager/$id",
        SubtaskDataSourceType.legal => '/v1/ContractBoard/ContractTimerManager/$id',
      };

      final response = await _apiClient.post(
        mainUrl,
        data: {"command": command?.name},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void changeProgress({
    required final SubtaskDataSourceType dataSourceType,
    required final String? slug,
    required final int value,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManager/CheckListManagerViewSet/$slug/ChangeProgress/",
        SubtaskDataSourceType.legal => "/v1/ContractBoard/ContractChecklistItem/$slug/ChangeProgress/",
      };

      final response = await _apiClient.put(
        mainUrl,
        data: {"progress": value},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  /// Not provided for legal
  void restore({
    required final SubtaskDataSourceType dataSourceType,
    required final String? id,
    required final Function(GenericResponse<SubtaskReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final String mainUrl = switch(dataSourceType) {
        SubtaskDataSourceType.project => "/v1/ProjectManagerExtra/CheckListArchiveManager/$id/RestoreACheckList/",
        SubtaskDataSourceType.legal => "/v1/ContractBoard/ContractChecklistItem/$id/Restore/",
      };

      final response = await _apiClient.post(
        mainUrl,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<SubtaskReadDto>.fromJson(response.data, fromMap: SubtaskReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
