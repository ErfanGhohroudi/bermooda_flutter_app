import 'package:get/get.dart';

import '../../data/data.dart';

class HrDatasources {
  static void init() {
    // --- Human Resources Data Sources ---
    Get.lazyPut<HumanResourceDatasource>(() => HumanResourceDatasource(), fenix: true);
    Get.lazyPut<HrSectionDatasource>(() => HrSectionDatasource(), fenix: true);
    Get.lazyPut<HRStatisticsDatasource>(() => HRStatisticsDatasource(), fenix: true);
    Get.lazyPut<MemberDatasource>(() => MemberDatasource(), fenix: true);
    Get.lazyPut<WorkShiftDatasource>(() => WorkShiftDatasource(), fenix: true);
    Get.lazyPut<AttendanceDatasource>(() => AttendanceDatasource(), fenix: true);
    Get.lazyPut<EmployeeRequestDatasource>(() => EmployeeRequestDatasource(), fenix: true);
  }
}
