part of '../../data.dart';

class LegalCaseReportDatasource extends BaseHistoryDatasource {
  @override
  String getAllUrl({
    required final int? id,
    required final int pageNumber,
    required final ReportType filter,
    final int perPageCount = 20,
  }) {
    return "/v1/ContractBoard/ContractReport"
        "?contract_case_id=$id"
        "&page_number=$pageNumber"
        "&per_page_count=$perPageCount"
        "&report_type=${filter.value ?? ''}";
  }

  @override
  String createUrl({required final IReportParams params}) {
    return "/v1/ContractBoard/ContractReport/";
  }

  @override
  Map<String, dynamic> createBody({required final int? id, required final IReportParams params}) {
    return {"contract_case_id": id, ...params.toMap()};
  }
}
