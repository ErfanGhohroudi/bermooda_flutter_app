import 'package:get/get.dart';

import '../../data/data.dart';

class LabelDatasources {
  static void init() {
    // --- Label Data Sources ---
    Get.lazyPut<LabelDatasource>(() => LabelDatasource(), fenix: true);
    Get.lazyPut<TaskInvoiceLabelDatasource>(() => TaskInvoiceLabelDatasource(), fenix: true);
    Get.lazyPut<TaskContractLabelDatasource>(() => TaskContractLabelDatasource(), fenix: true);
  }
}
