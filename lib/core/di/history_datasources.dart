import 'package:get/get.dart';

import '../../data/data.dart';

class HistoryDatasources {
  static void init() {
    // --- History Data Sources ---
    Get.lazyPut<TaskReportDatasource>(() => TaskReportDatasource(), fenix: true);
    Get.lazyPut<LegalCaseReportDatasource>(() => LegalCaseReportDatasource(), fenix: true);
    Get.lazyPut<CustomerReportDatasource>(() => CustomerReportDatasource(), fenix: true);
  }
}
