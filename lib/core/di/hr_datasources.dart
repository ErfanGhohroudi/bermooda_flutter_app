import 'package:get/get.dart';

import '../../data/data.dart';

class HrDatasources {
  static void init() {
    // --- Human Resources Data Sources ---
    Get.lazyPut<HumanResourceDatasource>(() => HumanResourceDatasource(), fenix: true);
    Get.lazyPut<HrSectionDatasource>(() => HrSectionDatasource(), fenix: true);
    Get.lazyPut<HRStatisticsDatasource>(() => HRStatisticsDatasource(), fenix: true);
    Get.lazyPut<MemberDatasource>(() => MemberDatasource(), fenix: true);
    Get.lazyPut<AttendanceDatasource>(() => AttendanceDatasource(), fenix: true);
    Get.lazyPut<EmployeeRequestDatasource>(() => EmployeeRequestDatasource(), fenix: true);

    // --- Workshift Data Sources ---
    Get.lazyPut<WorkShiftDatasource>(() => WorkShiftDatasource(), fenix: true);
    Get.lazyPut<YearShiftDatasource>(() => YearShiftDatasource(), fenix: true);
    Get.lazyPut<MonthShiftDatasource>(() => MonthShiftDatasource(), fenix: true);
    Get.lazyPut<DailyShiftDatasource>(() => DailyShiftDatasource(), fenix: true);
    Get.lazyPut<ShiftTypeDatasource>(() => ShiftTypeDatasource(), fenix: true);
  }
}
