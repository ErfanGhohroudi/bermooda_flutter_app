part of '../../data.dart';

class CustomerInvoiceLabelDatasource extends BaseLabelDatasource {

  @override
  String getAllUrl({required final String? sourceId}) {
    return "/v1/CrmManager/CrmFactorLabelManager/?group_crm_id=$sourceId";
  }

  @override
  String createUrl() {
    return "/v1/CrmManager/CrmFactorLabelManager/";
  }

  @override
  String updateUrl({required final String? slug}) {
    return "/v1/CrmManager/CrmFactorLabelManager/$slug/";
  }

  @override
  String deleteUrl({required final String? slug}) {
    return "/v1/CrmManager/CrmFactorLabelManager/$slug/";
  }

  @override
  Map<String, dynamic> createUpdateBody({required final String? sourceId, required final String title, required final String? colorCode}) {
    return {
      "group_crm_id": sourceId,
      "title": title,
      "color_code": colorCode,
    };
  }
}
