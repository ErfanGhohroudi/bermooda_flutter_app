part of '../../data.dart';

class TaskInvoiceLabelDatasource extends BaseLabelDatasource {
  @override
  String getAllUrl({required final String? sourceId}) {
    return "/v1/ProjectManager/ProjectFactorLabelManager/?project_id=$sourceId";
  }

  @override
  String createUrl() {
    return "/v1/ProjectManager/ProjectFactorLabelManager/";
  }

  @override
  String updateUrl({required final String? slug}) {
    return "/v1/ProjectManager/ProjectFactorLabelManager/$slug/";
  }

  @override
  String deleteUrl({required final String? slug}) {
    return "/v1/ProjectManager/ProjectFactorLabelManager/$slug/";
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
