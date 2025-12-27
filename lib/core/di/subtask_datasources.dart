import 'package:get/get.dart';

import '../../data/data.dart';

class SubtaskDatasources {
  static void init() {
    Get.lazyPut<SubtaskDatasource>(() => SubtaskDatasource(), fenix: true);
  }
}
