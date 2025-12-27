part of '../../data.dart';

class CustomerContractLabelDatasource extends BaseLabelDatasource {
  @override
  String getAllUrl({required final String? sourceId}) {
    return "/v1/CrmManagerExtra/CustomerContractTypeManager/?group_crm_id=$sourceId";
  }

  @override
  String createUrl() {
    return "/v1/CrmManagerExtra/CustomerContractTypeManager/";
  }

  @override
  String updateUrl({required final String? slug}) {
    return "/v1/CrmManagerExtra/CustomerContractTypeManager/$slug/";
  }

  @override
  String deleteUrl({required final String? slug}) {
    return "/v1/CrmManagerExtra/CustomerContractTypeManager/$slug/";
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
