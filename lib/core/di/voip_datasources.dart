import 'package:get/get.dart';

import '../../view/modules/voip/data/datasources/voip_datasource.dart';
import '../../view/modules/voip/data/datasources/voip_departments_datasource.dart';


class VoipDatasources {
  static void init() {
    // --- Voip Module Data Sources ---
    Get.lazyPut<VoipDatasource>(() => VoipDatasource(), fenix: true);
    Get.lazyPut<VoipDepartmentsDatasource>(() => VoipDepartmentsDatasource(), fenix: true);
  }
}
