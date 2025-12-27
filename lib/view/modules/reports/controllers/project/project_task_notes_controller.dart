import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../interfaces/report_controller.dart';

class ProjectTaskNotesController extends ReportController {
  ProjectTaskNotesController({
    required super.sourceId,
    super.canEdit,
  }) : super(
    datasource: Get.find<TaskReportDatasource>(),
    showFilters: false,
    invoiceLabelDatasource: null,
    contractLabelDatasource: null,
    showTimelineIndicators: false,
    showFloatingActionButton: true,
    initialFilter: ReportType.note,
  );
}
