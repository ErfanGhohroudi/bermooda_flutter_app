import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../interfaces/report_controller.dart';

class CrmCustomerReportsController extends ReportController {
  CrmCustomerReportsController({
    required super.sourceId,
    super.canEdit,
  }) : super(
    datasource: Get.find<CustomerReportDatasource>(),
    showFilters: false,
    invoiceLabelDatasource: null,
    contractLabelDatasource: null,
    showTimelineIndicators: true,
    showFloatingActionButton: false,
    initialFilter: ReportType.all,
  );
}
