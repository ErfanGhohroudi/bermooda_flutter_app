part of '../../data.dart';

class TaskContractLabelDatasource extends BaseLabelDatasource {
  @override
  String getAllUrl({required final String? sourceId}) {
    return "/v1/ProjectManagerExtra/TaskContractTypeManager/?project_id=$sourceId";
  }

  @override
  String createUrl() {
    return "/v1/ProjectManagerExtra/TaskContractTypeManager/";
  }

  @override
  String updateUrl({required final String? slug}) {
    return "/v1/ProjectManagerExtra/TaskContractTypeManager/$slug/";
  }

  @override
  String deleteUrl({required final String? slug}) {
    return "/v1/ProjectManagerExtra/TaskContractTypeManager/$slug/";
  }

  @override
  Map<String, dynamic> createUpdateBody({required final String? sourceId, required final String title, required final String? colorCode}) {
    return {
      "project_id": sourceId,
      "title": title,
      "color_code": colorCode,
    };
  }
}
