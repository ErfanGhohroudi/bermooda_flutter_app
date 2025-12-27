import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../interfaces/report_controller.dart';

class LegalCaseNotesController extends ReportController {
  LegalCaseNotesController({
    required super.sourceId,
    super.canEdit,
  }) : super(
    datasource: Get.find<LegalCaseReportDatasource>(),
    showFilters: false,
    invoiceLabelDatasource: null,
    contractLabelDatasource: null,
    showTimelineIndicators: false,
    showFloatingActionButton: true,
    initialFilter: ReportType.note,
  );
}
