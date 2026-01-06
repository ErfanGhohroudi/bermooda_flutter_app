import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import 'workshift_detail_controller.dart';
import 'widgets/workshift_month_calendar.dart';
import 'widgets/workshift_year_month_header.dart';

class WorkshiftDetailPage extends StatefulWidget {
  const WorkshiftDetailPage({
    required this.workShiftSlug,
    required this.departmentSlug,
    this.initialSetup = false,
    this.draftShifts,
    super.key,
  });

  final String workShiftSlug;
  final String departmentSlug;
  final bool initialSetup;
  final Set<DailyShiftParams>? draftShifts;

  @override
  State<WorkshiftDetailPage> createState() => _WorkshiftDetailPageState();
}

class _WorkshiftDetailPageState extends State<WorkshiftDetailPage> {
  late final WorkshiftDetailController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      WorkshiftDetailController(
        workShiftSlug: widget.workShiftSlug,
        departmentSlug: widget.departmentSlug,
        initialSetup: widget.initialSetup,
        draftShifts: widget.draftShifts,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Obx(() {
          if (ctrl.pageState.isLoaded()) {
            return Text(ctrl.workShift.title);
          }
          return const SizedBox.shrink();
        }),
      ),
      bottomNavigationBar: Obx(
        () => ctrl.haveAdminAccess
            ? SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: UElevatedButton(
                    enable: ctrl.draftShifts.isNotEmpty,
                    title: s.save,
                    width: double.maxFinite,
                    isLoading: ctrl.saveButtonState.isLoading(),
                    onTap: ctrl.onSave,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: Obx(
        () {
          if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
            return const Center(child: WCircularLoading());
          }

          if (ctrl.pageState.isError()) {
            return Center(child: WErrorWidget(onTapButton: ctrl.onRefresh));
          }

          if (ctrl.pageState.isLoaded() && ctrl.yearShifts.isEmpty) {
            return const Center(child: WEmptyWidget());
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              spacing: 12,
              children: [
                WorkshiftYearMonthHeader(
                  years: ctrl.yearShifts,
                  selectedYear: ctrl.selectedYearShift.value,
                  months: ctrl.monthShifts,
                  selectedMonth: ctrl.selectedMonthShift.value,
                  onYearChanged: ctrl.onYearSelected,
                  onMonthChanged: ctrl.onMonthSelected,
                ),
                Expanded(
                  child: WorkshiftMonthCalendar(
                    month: ctrl.selectedJalaliMonth.value,
                    assignmentsByDate: ctrl.assignmentsByDate,
                    shiftTypeRegistry: ctrl.shiftTypeRegistry,
                    onDayTap: ctrl.onDayTap,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
