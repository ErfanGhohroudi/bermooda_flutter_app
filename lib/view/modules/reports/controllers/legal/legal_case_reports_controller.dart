import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../interfaces/report_controller.dart';

class LegalCaseReportsController extends ReportController {
  LegalCaseReportsController({
    required super.sourceId,
    super.canEdit,
  }) : super(
    datasource: Get.find<LegalCaseReportDatasource>(),
    showFilters: false,
    invoiceLabelDatasource: null,
    contractLabelDatasource: null,
    showTimelineIndicators: true,
    showFloatingActionButton: false,
    initialFilter: ReportType.all,
  );
}
