import 'package:get/get.dart';

import '../../data/data.dart';

class ProjectDatasources {
  static void init() {
    // --- Project Management Data Sources ---
    Get.lazyPut<ProjectDatasource>(() => ProjectDatasource(), fenix: true);
    Get.lazyPut<ProjectStatisticsDatasource>(() => ProjectStatisticsDatasource(), fenix: true);
    Get.lazyPut<TaskDatasource>(() => TaskDatasource(), fenix: true);
    Get.lazyPut<TaskArchiveDatasource>(() => TaskArchiveDatasource(), fenix: true);
    Get.lazyPut<KanbanDatasource>(() => KanbanDatasource(), fenix: true);
  }
}
