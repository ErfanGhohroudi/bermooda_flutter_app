import 'package:get/get.dart';

import '../../data/data.dart';

class WarehouseDatasources {
  static void init() {
    // --- Warehouse Module Data Sources ---
    Get.lazyPut<WarehouseDatasource>(() => WarehouseDatasource(), fenix: true);
  }
}
