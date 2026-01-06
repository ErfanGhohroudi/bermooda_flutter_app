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
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: ctrl.isEndOfList ? 100 : 10),
                        itemCount: ctrl.workShifts.length,
                        itemBuilder: (final context, final index) {
                          final workShift = ctrl.workShifts[index];
                          return _buildWorkShiftCard(context, workShift);
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

  Widget _buildWorkShiftCard(final BuildContext context, final WorkShiftReadDto workShift) {
    return WCard(
      showBorder: true,
      onTap: ctrl.haveAdminAccess ? () => ctrl.showCreateUpdateBottomSheet(workShift: workShift) : null,
      horPadding: 12,
      verPadding: 12,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workShift.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).titleMedium().bold(),
                    if (workShift.years.isNotEmpty)
                      Text(
                        '${s.year}: ${workShift.years.length}',
                        maxLines: 1,
                      ).bodySmall(color: context.theme.hintColor).marginOnly(top: 4),
                  ],
                ),
              ),
              if (ctrl.haveAdminAccess) ...[
                IconButton(
                  onPressed: () => ctrl.showCreateUpdateBottomSheet(workShift: workShift),
                  icon: UImage(AppIcons.editOutline, color: context.theme.primaryColor, size: 22),
                  tooltip: s.edit,
                ),
                IconButton(
                  onPressed: () => ctrl.deleteWorkShift(workShift),
                  icon: const UImage(AppIcons.delete, color: AppColors.red, size: 22),
                  tooltip: s.delete,
                ),
              ],
            ],
          ),
          if (workShift.allowedOvertimeHoursNumber != null ||
              workShift.allowedLeaveHoursNumber != null ||
              workShift.allowedMissionHoursNumber != null ||
              workShift.allowedLeaveEarlyHoursNumber != null ||
              workShift.allowedOverdueHoursNumber != null) ...[
            const Divider(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (workShift.allowedOvertimeHoursNumber != null)
                  _buildInfoChip(
                    context,
                    '${s.overtime}: ${workShift.allowedOvertimeHoursNumber} ${s.hours}',
                  ),
                if (workShift.allowedLeaveHoursNumber != null)
                  _buildInfoChip(
                    context,
                    '${s.leave}: ${workShift.allowedLeaveHoursNumber} ${s.hours}',
                  ),
                if (workShift.allowedMissionHoursNumber != null)
                  _buildInfoChip(
                    context,
                    '${s.mission}: ${workShift.allowedMissionHoursNumber} ${s.hours}',
                  ),
                if (workShift.allowedLeaveEarlyHoursNumber != null)
                  _buildInfoChip(
                    context,
                    '${s.leave} ${s.early}: ${workShift.allowedLeaveEarlyHoursNumber} ${s.hours}',
                  ),
                if (workShift.allowedOverdueHoursNumber != null)
                  _buildInfoChip(
                    context,
                    '${s.tardiness}: ${workShift.allowedOverdueHoursNumber} ${s.hours}',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(final BuildContext context, final String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(color: context.theme.hintColor),
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
