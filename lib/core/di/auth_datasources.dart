import 'package:get/get.dart';

import '../../data/data.dart';

class AuthDatasources {
  static void init() {
    // --- Auth & User Data Sources ---
    Get.lazyPut<AccessTokenDatasource>(() => AccessTokenDatasource(), fenix: true);
    Get.lazyPut<LoginDataSource>(() => LoginDataSource(), fenix: true);
    Get.lazyPut<RegisterDataSource>(() => RegisterDataSource(), fenix: true);
    Get.lazyPut<UserDatasource>(() => UserDatasource(), fenix: true);
    Get.lazyPut<WorkspaceDatasource>(() => WorkspaceDatasource(), fenix: true);
  }
}
