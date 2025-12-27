part of '../../data.dart';

class LegalLabelDatasource extends BaseLabelDatasource {

  @override
  String getAllUrl({required final String? sourceId}) {
    return "/v1/ContractBoard/ContractLabel/?contract_board_id=$sourceId";
  }

  @override
  String createUrl() {
    return "/v1/ContractBoard/ContractLabel/";
  }

  @override
  String updateUrl({required final String? slug}) {
    return "/v1/ContractBoard/ContractLabel/$slug/";
  }

  @override
  String deleteUrl({required final String? slug}) {
    return "/v1/ContractBoard/ContractLabel/$slug/";
  }

  @override
  Map<String, dynamic> createUpdateBody({required final String? sourceId, required final String title, required final String? colorCode}) {
    return {
      "contract_board_id": sourceId,
      "title": title,
      "color_code": colorCode,
    };
  }
}

