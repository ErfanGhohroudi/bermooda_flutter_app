part of '../../data.dart';

class CustomerReportDatasource extends BaseHistoryDatasource {

  @override
  String getAllUrl({required final int? id, required final int pageNumber, required final ReportType filter, final int perPageCount = 20}) {
    return "/v1/CrmManager/GroupCrmMessageManager/?customer_id=$id&page_number=$pageNumber&per_page_count=$perPageCount&message_type=${filter.value ?? ''}";
  }

  @override
  String createUrl({required final IReportParams params}) {
    return "/v1/CrmManager/GroupCrmMessageManager/${params.type.name}/";
  }

  @override
  Map<String, dynamic> createBody({required final int? id, required final IReportParams params}) {
    return {"customer_id": id, ...params.toMap()};
  }
}
