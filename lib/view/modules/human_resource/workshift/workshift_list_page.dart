import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import 'workshift_list_controller.dart';

class WorkshiftListPage extends StatefulWidget {
  const WorkshiftListPage({
    required this.departmentSlug,
    super.key,
  });

  final String departmentSlug;

  @override
  State<WorkshiftListPage> createState() => _WorkshiftListPageState();
}

class _WorkshiftListPageState extends State<WorkshiftListPage> {
  late final WorkshiftListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(WorkshiftListController(departmentSlug: widget.departmentSlug));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(title: Text(s.workShift)),
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAdminAccess
          ? FloatingActionButton(
              heroTag: "WorkshiftListFAB",
              onPressed: () => ctrl.showCreateUpdateBottomSheet(),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () {
              if (ctrl.pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              }

              if (ctrl.pageState.isLoaded() && ctrl.workShifts.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
              return const SizedBox.shrink();
            },
          ),
          Column(
            children: [
              if (false)
                WSearchField(
                  controller: ctrl.searchController,
                  borderRadius: 0,
                  height: 50,
                  onChanged: (final value) => ctrl.onSearch(),
                ),
              Expanded(
                child: Obx(
                  () {
                    if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
                      return _buildShimmerLoading();
                    }

                    if (ctrl.pageState.isError()) {
                      return const SizedBox.shrink();
                    }

                    return WSmartRefresher(
                      controller: ctrl.refreshController,
                      onRefresh: ctrl.onRefresh,
                      onLoading: ctrl.loadMore,
                      child: ListView.builder(
                        itemCount: ctrl.workShifts.length,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 10),
                        itemBuilder: (final context, final index) {
                          final workShift = ctrl.workShifts[index];
                          return _buildWorkShiftCard(workShift);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkShiftCard(final WorkShiftReadDto workShift) {
    final hasAnyLimits =
        workShift.allowedOvertimeHoursNumber != null ||
        workShift.allowedLeaveHoursNumber != null ||
        workShift.allowedMissionHoursNumber != null ||
        workShift.allowedLeaveEarlyHoursNumber != null ||
        workShift.allowedOverdueHoursNumber != null;

    bool isExpanded = false;

    return StatefulBuilder(
      builder: (final context, final setState) {
        void toggleExpansion() => setState(() => isExpanded = !isExpanded);

        return WCard(
          showBorder: true,
          onTap: toggleExpansion,
          horPadding: 16,
          verPadding: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      workShift.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).titleMedium().bold(),
                  ),
                  if (ctrl.haveAdminAccess)
                    WMoreButtonIcon(
                      items: [
                        WPopupMenuItem(
                          title: s.edit,
                          icon: AppIcons.editOutline,
                          titleColor: AppColors.green,
                          iconColor: AppColors.green,
                          onTap: () => ctrl.showCreateUpdateBottomSheet(workShift: workShift),
                        ),
                        WPopupMenuItem(
                          title: s.delete,
                          icon: AppIcons.delete,
                          titleColor: AppColors.red,
                          iconColor: AppColors.red,
                          onTap: () => ctrl.deleteWorkShift(workShift),
                        ),
                      ],
                    ),
                ],
              ),

              // Years
              if (workShift.years.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildYearsChips(context, workShift),
              ],

              // Limits/Rules
              if (hasAnyLimits) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => toggleExpansion(),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s.more).bodySmall(color: context.theme.primaryColor),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: context.theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      const Divider(height: 0),
                      const SizedBox(height: 10),
                    ],
                    AnimatedSize(
                      duration: 300.milliseconds,
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: isExpanded ? _buildLimitsWrap(context, workShift).pOnly(bottom: 12) : null,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildYearsChips(final BuildContext context, final WorkShiftReadDto workShift) {
    final years = workShift.years.map((final e) => e.year.toString()).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        UImage(
          AppIcons.calendarOutline,
          size: 20,
          color: context.theme.hintColor,
        ),
        Flexible(
          child: Wrap(
            spacing: 4,
            runSpacing: 6,
            children: List.generate(years.length, (final index) {
              final year = years[index];
              return WLabel(
                text: year,
                verticalPadding: 1,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitsWrap(final BuildContext context, final WorkShiftReadDto workShift) {
    return Wrap(
      spacing: 4,
      runSpacing: 6,
      children: [
        if (workShift.allowedOvertimeHoursNumber != null)
          _buildInfoChip(
            context,
            iconString: AppIcons.clockOutline,
            label: s.overtimeLimit,
            value: '${workShift.allowedOvertimeHoursNumber} ${s.hours}',
          ),
        if (workShift.allowedMissionHoursNumber != null)
          _buildInfoChip(
            context,
            iconString: AppIcons.missionOutline,
            label: s.missionLimit,
            value: '${workShift.allowedMissionHoursNumber} ${s.hours}',
          ),
        if (workShift.allowedLeaveHoursNumber != null)
          _buildInfoChip(
            context,
            iconString: AppIcons.leaveOutline,
            label: s.leaveEntitlement,
            value: '${workShift.allowedLeaveHoursNumber} ${s.hours}',
          ),
        if (workShift.allowedOverdueHoursNumber != null)
          _buildInfoChip(
            context,
            iconString: AppIcons.warningOutline,
            label: s.tardinessAllowance,
            value: '${workShift.allowedOverdueHoursNumber} ${s.hours}',
          ),
        if (workShift.allowedLeaveEarlyHoursNumber != null)
          _buildInfoChip(
            context,
            iconString: AppIcons.clockOutline,
            label: s.earlyOutAllowance,
            value: '${workShift.allowedLeaveEarlyHoursNumber} ${s.hours}',
          ),
      ],
    );
  }

  Widget _buildInfoChip(
    final BuildContext context, {
    required final String iconString,
    required final String label,
    required final String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          UImage(
            iconString,
            size: 14,
            color: context.theme.hintColor,
          ),
          Flexible(
            child: Text('$label: $value', maxLines: 1).bodySmall(
              color: context.theme.hintColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (final context, final index) => WCard(
        child: SizedBox(width: context.width, height: 100),
      ),
    ).shimmer();
  }
}
