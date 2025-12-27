part of '../../data.dart';

enum LabelDataSourceType {
  project,
  legal,
  projectTaskInvoice,
  projectTaskContract,
  crmCustomerInvoice,
  crmCustomerContract,
}

class LabelDatasource {
  final ApiClient _apiClient = Get.find();

  void getLabels({
    required final LabelDataSourceType dataSourceType,
    required final String sourceId,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    try {
      final mainUrl = switch (dataSourceType) {
        LabelDataSourceType.project => "/v1/ProjectManager/LabelTaskManager",
        LabelDataSourceType.legal => "/v1/ContractBoard/ContractLabel/",
        LabelDataSourceType.projectTaskInvoice => "/v1/ProjectManager/ProjectFactorLabelManager/",
        LabelDataSourceType.projectTaskContract => "/v1/ProjectManagerExtra/TaskContractTypeManager/",
        LabelDataSourceType.crmCustomerInvoice => "/v1/CrmManager/CrmFactorLabelManager/",
        LabelDataSourceType.crmCustomerContract => "/v1/CrmManagerExtra/CustomerContractTypeManager/",
      };

      final queryParameters = switch (dataSourceType) {
        LabelDataSourceType.project ||
        LabelDataSourceType.projectTaskInvoice ||
        LabelDataSourceType.projectTaskContract => {"project_id": sourceId},
        LabelDataSourceType.legal => {"contract_board_id": sourceId},
        LabelDataSourceType.crmCustomerInvoice || LabelDataSourceType.crmCustomerContract => {"group_crm_id": sourceId},
      };

      final response = await _apiClient.get(
        mainUrl,
        queryParameters: queryParameters,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
  }

  void createLabel({
    required final LabelDataSourceType dataSourceType,
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final mainUrl = switch (dataSourceType) {
        LabelDataSourceType.project => "/v1/ProjectManager/LabelTaskManager",
        LabelDataSourceType.legal => "/v1/ContractBoard/ContractLabel/",
        LabelDataSourceType.projectTaskInvoice => "/v1/ProjectManager/ProjectFactorLabelManager/",
        LabelDataSourceType.projectTaskContract => "/v1/ProjectManagerExtra/TaskContractTypeManager/",
        LabelDataSourceType.crmCustomerInvoice => "/v1/CrmManager/CrmFactorLabelManager/",
        LabelDataSourceType.crmCustomerContract => "/v1/CrmManagerExtra/CustomerContractTypeManager/",
      };

      final data = switch (dataSourceType) {
        LabelDataSourceType.project || LabelDataSourceType.projectTaskInvoice || LabelDataSourceType.projectTaskContract => {
          "project_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
        LabelDataSourceType.legal => {
          "contract_board_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
        LabelDataSourceType.crmCustomerInvoice || LabelDataSourceType.crmCustomerContract => {
          "group_crm_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
      };

      final response = await _apiClient.post(
        mainUrl,
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void updateLabel({
    required final LabelDataSourceType dataSourceType,
    required final int? id,

    /// required for invoice and contract
    final String? slug,
    required final String sourceId,
    required final String title,
    required final String? colorCode,
    required final Function(GenericResponse<LabelReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final mainUrl = switch (dataSourceType) {
        LabelDataSourceType.project => "/v1/ProjectManager/LabelTaskManager/$id",
        LabelDataSourceType.legal => "/v1/ContractBoard/ContractLabel/$id/",
        LabelDataSourceType.projectTaskInvoice => "/v1/ProjectManager/ProjectFactorLabelManager/$slug/",
        LabelDataSourceType.projectTaskContract => "/v1/ProjectManagerExtra/TaskContractTypeManager/$slug/",
        LabelDataSourceType.crmCustomerInvoice => "/v1/CrmManager/CrmFactorLabelManager/$slug/",
        LabelDataSourceType.crmCustomerContract => "/v1/CrmManagerExtra/CustomerContractTypeManager/$slug/",
      };

      final data = switch (dataSourceType) {
        LabelDataSourceType.project || LabelDataSourceType.projectTaskInvoice || LabelDataSourceType.projectTaskContract => {
          "project_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
        LabelDataSourceType.legal => {
          "contract_board_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
        LabelDataSourceType.crmCustomerInvoice || LabelDataSourceType.crmCustomerContract => {
          "group_crm_id": sourceId,
          "title": title,
          "color_code": colorCode,
        },
      };

      final response = await _apiClient.put(
        mainUrl,
        data: data,
        skipRetry: !withRetry,
      );

      if (response.isOk) {
        onResponse(GenericResponse<LabelReadDto>.fromJson(response.data, fromMap: LabelReadDto.fromMap));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on dio.DioException {
      onError(GenericResponse());
    }
    AppLoading.dismissLoading();
  }

  void deleteLabel({
    required final LabelDataSourceType dataSourceType,
    required final int? id,

    /// required for invoice and contract
    final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  }) async {
    AppLoading.showLoading();
    try {
      final mainUrl = switch (dataSourceType) {
        LabelDataSourceType.project => "/v1/ProjectManager/LabelTaskManager/$id",
        LabelDataSourceType.legal => "/v1/ContractBoard/ContractLabel/$id/",
        LabelDataSourceType.projectTaskInvoice => "/v1/ProjectManager/ProjectFactorLabelManager/$slug/",
        LabelDataSourceType.projectTaskContract => "/v1/ProjectManagerExtra/TaskContractTypeManager/$slug/",
        LabelDataSourceType.crmCustomerInvoice => "/v1/CrmManager/CrmFactorLabelManager/$slug/",
        LabelDataSourceType.crmCustomerContract => "/v1/CrmManagerExtra/CustomerContractTypeManager/$slug/",
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
}
