part of '../../data.dart';

class LegalCaseDatasource {
  final ApiClient _apiClient = Get.find();

  //-------------------------------------------------------------------
  // Case Methods
  //-------------------------------------------------------------------

  void create({
    required final String departmentId,
    required final String title,
    required final String sectionSlug,
    required final Function(GenericResponse<LegalCaseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCase/",
        data: {
          "title": title,
          "contract_board_id": departmentId,
          "column_slug": sectionSlug,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseReadDto>.fromJson(response.data, fromMap: LegalCaseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void update({
    required final String? id,
    required final String title,
    required final String? description,
    required final Function(GenericResponse<LegalCaseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ContractBoard/ContractCase/$id/",
        data: {
          "title": title,
          "description": description,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseReadDto>.fromJson(response.data, fromMap: LegalCaseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void delete({
    required final int caseId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ContractBoard/ContractCase/$caseId/",
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

  void getCaseById({
    required final int caseId,
    required final Function(GenericResponse<LegalCaseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/ContractCase/$caseId/",
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseReadDto>.fromJson(response.data, fromMap: LegalCaseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void changeLegalCaseStatusToCompleted({
    required final int legalCaseId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCase/$legalCaseId/Complate/",
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

  //-------------------------------------------------------------------
  // Case Steps Methods
  //-------------------------------------------------------------------

  void createCaseStep({
    required final int caseId,
    required final String title,
    required final int stepNumber,
    required final Function(GenericResponse<LegalCaseStep> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCaseStep/",
        data: {
          "contract_case_id": caseId,
          "title": title,
          "step_number": stepNumber,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseStep>.fromJson(response.data, fromMap: LegalCaseStep.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateCaseStep({
    required final int stepId,
    required final String title,
    required final int stepNumber,
    required final Function(GenericResponse<LegalCaseStep> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ContractBoard/ContractCaseStep/$stepId/",
        data: {
          "title": title,
          "step_number": stepNumber,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseStep>.fromJson(response.data, fromMap: LegalCaseStep.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void deleteCaseStep({
    required final int stepId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ContractBoard/ContractCaseStep/$stepId/",
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

  void getCaseSteps({
    required final int caseId,
    required final Function(GenericResponse<LegalCaseStep> response) onResponse, // List of [LegalCaseStep]
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/ContractCaseStep/",
        queryParameters: {"contract_case_id": caseId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseStep>.fromJson(response.data, fromMap: LegalCaseStep.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void changeCaseStepStatus({
    required final int stepId,
    required final bool isCompleted,
    required final Function(GenericResponse<LegalCaseStep> response) onResponse, // LegalCaseStep
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCaseStep/complete/",
        data: {
          "step_id": stepId,
          "is_completed": isCompleted,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseStep>.fromJson(response.data, fromMap: LegalCaseStep.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void reorderCaseSteps({
    required final int caseId,
    required final List<LegalCaseStep> steps,
    required final Function(GenericResponse<LegalCaseStep> response) onResponse, // List of [LegalCaseStep]
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCaseStep/reorder/",
        data: {
          "contract_case_id": caseId,
          "steps_order": steps
              .mapIndexed(
                (final index, final s) => {
                  "id": s.id,
                  "step_number": index + 1,
                },
              )
              .toList(),
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseStep>.fromJson(response.data, fromMap: LegalCaseStep.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  //-------------------------------------------------------------------
  // Case Document Methods
  //-------------------------------------------------------------------

  void getDocuments({
    required final int caseId,
    required final Function(GenericResponse<LegalCaseDocumentDto> response) onResponse, // List of [LegalCaseDocumentDto]
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/Document/",
        queryParameters: {
          "contract_case_id": caseId,
          "page_number": 1,
          "per_page_count": 200,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseDocumentDto>.fromJson(response.data, fromMap: LegalCaseDocumentDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createDocument({
    required final int caseId,
    required final String title,
    required final int fileId,
    required final Function(GenericResponse<LegalCaseDocumentDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/Document/",
        data: {
          "contract_case_id": caseId,
          "title": title,
          "file_id": fileId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseDocumentDto>.fromJson(response.data, fromMap: LegalCaseDocumentDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void updateDocument({
    required final int id,
    required final String title,
    required final int fileId,
    required final Function(GenericResponse<LegalCaseDocumentDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.put(
        "/v1/ContractBoard/Document/$id/",
        data: {
          "title": title,
          "file_id": fileId,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseDocumentDto>.fromJson(response.data, fromMap: LegalCaseDocumentDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void deleteDocument({
    required final int id,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ContractBoard/Document/$id/",
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

  //-------------------------------------------------------------------
  // Archive Methods
  //-------------------------------------------------------------------

  void getArchivedCases({
    required final String contractBoardId,
    required final int pageNumber,
    final int perPageCount = 20,
    final String? search,
    required final Function(GenericResponse<LegalCaseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/ContractCase/Archived/",
        queryParameters: {
          "contract_board_id": contractBoardId,
          "page_number": pageNumber,
          "per_page_count": perPageCount,
          if (search != null && search.isNotEmpty) "search": search,
        },
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseReadDto>.fromJson(response.data, fromMap: LegalCaseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void restoreCase({
    required final int legalCaseId,
    required final Function(GenericResponse<LegalCaseReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/ContractCase/$legalCaseId/Restore/",
        data: {},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LegalCaseReadDto>.fromJson(response.data, fromMap: LegalCaseReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }
}
