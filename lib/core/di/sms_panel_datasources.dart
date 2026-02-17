import 'package:get/get.dart';

import '../../view/modules/sms/data/datasources/sms_panel_datasource.dart';
import '../../view/modules/sms/data/datasources/sms_panel_departments_datasource.dart';

class SmsPanelDatasources {
  static void init() {
    // --- SMS Panel Module Data Sources ---
    Get.lazyPut<SmsPanelDatasource>(() => SmsPanelDatasource(), fenix: true);
    Get.lazyPut<SmsPanelDepartmentsDatasource>(() => SmsPanelDepartmentsDatasource(), fenix: true);
  }
}
