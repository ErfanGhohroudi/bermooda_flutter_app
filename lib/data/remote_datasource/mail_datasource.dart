part of '../data.dart';

class MailDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  void getAllLetters({
    required final int pageNumber,
    required final Function(List<LetterReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final String? query,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/MailManager/Mail",
        queryParameters: {
          "workspace_id": core.currentWorkspace.value.id,
          if ((query ?? '') != '') "&search_query": query,
          "page_number": pageNumber,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(
          response.data?["data"]?["list"] == null
              ? []
              : List<LetterReadDto>.from(response.data["data"]["list"].map((final x) => LetterReadDto.fromMap(x))),
        );
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void getAMail({
    required final String id,
    required final Function(GenericResponse<LetterReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/MailManager/Mail/$id",
        queryParameters: {
          "workspace_id": core.currentWorkspace.value.id,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LetterReadDto>.fromJson(response.data, fromMap: LetterReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
  }

  void addSignature({
    required final int? id,
    required final int? fileId,
    required final Function(GenericResponse<Recipient> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/MailManager/AddSignatureToMail/$id",
        data: {"signature_file_id": fileId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<Recipient>.fromJson(response.data, fromMap: Recipient.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void getCurrentStatus({
    required final int? id,
    required final Function(GenericResponse<CurrentMailStatus> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.get(
        "/v1/MailManager/MailStatusManager/$id",
        queryParameters: {
          "workspace_id": core.currentWorkspace.value.id,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<CurrentMailStatus>.fromJson(response.data, fromMap: CurrentMailStatus.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void changeStatus({
    required final int? id,
    required final int? statusId,
    required final List<int> userIdList,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.put(
        "/v1/MailManager/MailStatusManager/$id",
        data: {
          "workspace_id": core.currentWorkspace.value.id,
          if (statusId != null) "status_id": statusId,
          if (userIdList.isNotEmpty) "user_list": userIdList,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse();
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException catch(e) {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
