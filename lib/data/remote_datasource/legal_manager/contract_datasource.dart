part of '../../data.dart';

class ContractDatasource {
  final ApiClient _apiClient = Get.find();

  void create({
    required final ContractParams dto,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.post(
        "/v1/ContractBoard/contract/storeContract",
        data: dto.toMap(),
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
  }

  void delete({
    required final int contractId,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final response = await _apiClient.delete(
        "/v1/ContractBoard/Contract/$contractId/",
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

  void getContract({
    required final int caseId,
    required final Function(ContractReadDto? response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final response = await _apiClient.get(
        "/v1/ContractBoard/Contract/",
        queryParameters: {"contract_case_id": caseId},
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        final res = GenericResponse<ContractReadDto>.fromJson(response.data, fromMap: ContractReadDto.fromMap);
        if (res.resultList != null && res.resultList!.isNotEmpty) {
          onResponse(res.resultList!.first);
        } else {
          onResponse(null);
        }
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }
}
