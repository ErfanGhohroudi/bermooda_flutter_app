import 'package:get/get.dart';
import '../../view/modules/support/data/datasources/support_datasource.dart';

class SupportDatasources {
  static void init() {
    Get.lazyPut<SupportDatasource>(() => SupportDatasource(), fenix: true);
  }
}
