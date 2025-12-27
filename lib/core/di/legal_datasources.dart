import 'package:get/get.dart';

import '../../data/data.dart';

class LegalDatasources {
  static void init() {
    // --- Legal Module Data Sources ---
    Get.lazyPut<ContractDatasource>(() => ContractDatasource(), fenix: true);
    Get.lazyPut<LegalCaseDatasource>(() => LegalCaseDatasource(), fenix: true);
    Get.lazyPut<LegalDatasource>(() => LegalDatasource(), fenix: true);
    Get.lazyPut<LegalSectionDatasource>(() => LegalSectionDatasource(), fenix: true);
    Get.lazyPut<LegalStatisticsDatasource>(() => LegalStatisticsDatasource(), fenix: true);
    Get.lazyPut<MyContractDatasource>(() => MyContractDatasource(), fenix: true);
  }
}
