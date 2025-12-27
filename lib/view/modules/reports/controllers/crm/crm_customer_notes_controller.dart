import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../interfaces/report_controller.dart';

class CrmCustomerNotesController extends ReportController {
  CrmCustomerNotesController({
    required super.sourceId,
    super.canEdit,
  }) : super(
         datasource: Get.find<CustomerReportDatasource>(),
         showFilters: false,
         invoiceLabelDatasource: null,
         contractLabelDatasource: null,
         showTimelineIndicators: false,
         showFloatingActionButton: true,
         initialFilter: ReportType.note,
       );
}
