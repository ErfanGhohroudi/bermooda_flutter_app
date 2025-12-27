import 'package:get/get.dart';

import '../../data/data.dart';

class FollowUpDatasources {
  static void init() {
    Get.lazyPut<CustomerFollowUpDatasource>(() => CustomerFollowUpDatasource(), fenix: true);
    Get.lazyPut<LegalFollowUpDatasource>(() => LegalFollowUpDatasource(), fenix: true);
  }
}
