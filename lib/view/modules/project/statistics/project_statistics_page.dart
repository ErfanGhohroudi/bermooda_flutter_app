import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/extensions/time_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'entities/performance_status_entity.dart';
import 'entities/stat_card_value_entity.dart';
import 'project_statistics_controller.dart';

class ProjectStatisticsPage extends StatefulWidget {
  const ProjectStatisticsPage({
    required this.project,
    super.key,
  });

  final ProjectReadDto project;

  @override
  State<ProjectStatisticsPage> createState() => _ProjectStatisticsPageState();
}

class _ProjectStatisticsPageState extends State<ProjectStatisticsPage> with ProjectStatisticsController {
  @override
  void initState() {
    super.initState();
    initialController(project: widget.project);
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(s.statistics)),
      body: Stack(
        children: [
          Obx(
            () {
              if (pageState.isError() && userStatisticsSummaries.isEmpty) {
                return Center(child: WErrorWidget(onTapButton: onRetry));
              }

              return const SizedBox.shrink();
            },
          ),
          Column(
            children: [
              // Filters
              _buildFilters(),
              Obx(() {
                if (pageState.value == PageState.loading) {
                  return const Center(child: WCircularLoading());
                }

                return WSmartRefresher(
                  controller: refreshController,
                  onRefresh: reloadStatistics,
                  onLoading: onLoading,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      // کارت‌های آمار کلی در بالای صفحه
                      SliverToBoxAdapter(
                        child: _buildOverallStatisticsCards(),
                      ),

                      // عنوان بخش لیست کاربران
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 8),
                          child: Row(
                            children: [
                              UImage(AppIcons.groupOutline, size: 20, color: context.theme.primaryColorDark),
                              const SizedBox(width: 8),
                              Text(
                                s.membersPerformance,
                                style: context.theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // لیست کاربران
                      if (userStatisticsSummaries.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: userStatisticsSummaries.length,
                            (final context, final index) {
                              final stat = userStatisticsSummaries[index];
                              return _buildUserStatisticsCard(
                                stat,
                              ).marginOnly(bottom: (index + 1) == userStatisticsSummaries.length && isAtEnd ? 70 : 0);
                            },
                          ),
                        )
                      else
                        const SliverToBoxAdapter(child: Center(child: WEmptyWidget())),
                    ],
                  ),
                );
              }).expanded(),
            ],
          ),
          WScrollToTopButton(
            scrollController: scrollController,
            show: showScrollToTop,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        WSearchField(
          controller: searchCtrl,
          borderRadius: 0,
          height: 50,
          onChanged: (final value) => reloadStatistics(),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Obx(
            () => Row(
              spacing: 4,
              children: StatisticsTimePeriodFilter.values.map(
                (final filter) {
                  final selected = selectedTimePeriodFilter.value == filter;
                  return FilterChip(
                    label: Text(filter.getTitle()).bodyMedium(color: selected ? Colors.white : null),
                    selected: selected,
                    onSelected: (final value) => setFilter(filter),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallStatisticsCards() {
    final statCardValues = _getStatCardValues();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // عنوان بخش آمار کلی
          Row(
            children: [
              UImage(AppIcons.statisticsOutline, size: 20, color: context.theme.primaryColorDark),
              const SizedBox(width: 8),
              Text(
                '${s.overallStatistics} (${widget.project.title ?? "- -"})',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // کارت‌های آمار کلی
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: statCardValues.map((final stat) => _buildOverallStatCard(stat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatCard(final StatCardValueEntity stat) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: stat.color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: stat.color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(stat.value).bodyMedium(fontSize: 20, color: stat.color).bold(),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stat.title).titleMedium(color: stat.color.withValues(alpha: 0.8)).bold(),
              Text(
                stat.subtitle,
                maxLines: 1,
              ).bodyMedium(
                color: stat.color.withValues(alpha: 0.6),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatisticsCard(final ProjectUserStatisticsSummary stat) {
    // محاسبه درصد موفقیت کارشناس
    final successRate = stat.totalTasksCount > 0 ? ((stat.doneTasksCount / stat.totalTasksCount) * 100).round() : 0;

    // تعیین وضعیت عملکرد کارشناس
    final performanceStatus = _getPerformanceStatus(stat);

    final statCardValues = _getStatCardValues(stat: stat);

    return WCard(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اطلاعات کاربر و وضعیت عملکرد
          Row(
            children: [
              // آواتار کاربر
              Stack(
                children: [
                  WCircleAvatar(
                    size: 50,
                    user: stat.userData,
                  ),
                  // نشانگر وضعیت عملکرد
                  Positioned(
                    bottom: 0,
                    right: !isPersianLang ? 0 : null,
                    left: isPersianLang ? 0 : null,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: performanceStatus.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.theme.cardColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // اطلاعات کاربر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(stat.userData.fullName ?? '- -').titleMedium(),
                    // وضعیت عملکرد
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: performanceStatus.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(performanceStatus.title).bodySmall(color: performanceStatus.color).bold(),
                    ),
                  ],
                ),
              ),

              // درصد موفقیت
              Column(
                children: [
                  Text('$successRate%').bodyLarge(color: performanceStatus.color).bold(),
                  Text(s.success).bodySmall(color: context.theme.hintColor),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // آمار تفصیلی وظایف
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: statCardValues.map((final stat) => _buildStatItem(stat)).toList(),
          ),
        ],
      ),
    );
  }

  PerformanceStatusEntity _getPerformanceStatus(final ProjectUserStatisticsSummary stat) {
    if (stat.totalTasksCount == 0) {
      return PerformanceStatusEntity(
        title: s.noActivity,
        color: Colors.grey,
      );
    }

    final successRate = (stat.doneTasksCount / stat.totalTasksCount) * 100;
    final delayedRate = (stat.overdueTasksCount / stat.totalTasksCount) * 100;

    if (successRate >= 80 && delayedRate <= 10) {
      return PerformanceStatusEntity(
        title: s.excellent,
        color: AppColors.green,
      );
    } else if (successRate >= 60 && delayedRate <= 20) {
      return PerformanceStatusEntity(
        title: s.good,
        color: AppColors.blue,
      );
    } else if (successRate >= 40 && delayedRate <= 30) {
      return PerformanceStatusEntity(
        title: s.fair,
        color: AppColors.orange,
      );
    } else {
      return PerformanceStatusEntity(
        title: s.needsImprovement,
        color: AppColors.red,
      );
    }
  }

  Widget _buildStatItem(final StatCardValueEntity stat) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            stat.color.withValues(alpha: 0.15),
            stat.color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: stat.color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          // آیکون و مقدار
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(stat.value).bodyMedium(fontSize: 20, color: stat.color).bold(),
            ],
          ),
          // عنوان و زیرعنوان
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                stat.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).bodyMedium(color: stat.color.withValues(alpha: 0.9)).bold(),
              Text(
                stat.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).bodySmall(color: stat.color.withValues(alpha: 0.6)),
            ],
          ),
        ],
      ),
    );
  }

  List<StatCardValueEntity> _getStatCardValues({final ProjectUserStatisticsSummary? stat}) {
    return [
      StatCardValueEntity(
        icon: Icons.assignment_outlined,
        title: s.tasks,
        value:
            stat?.totalTasksCount.toString().separateNumbers3By3() ??
            totalStatistics.value.totalTasksCount.toString().separateNumbers3By3(),
        color: Colors.blue,
        subtitle: s.totalTasks,
      ),
      StatCardValueEntity(
        icon: Icons.pending_outlined,
        title: s.inProgress,
        value:
            stat?.runningTasksCount.toString().separateNumbers3By3() ??
            totalStatistics.value.runningTasksCount.toString().separateNumbers3By3(),
        color: Colors.orange,
        subtitle: '${s.tasks} ${s.inProgress}',
      ),
      StatCardValueEntity(
        icon: Icons.check_circle_outline,
        title: s.completed,
        value:
            stat?.doneTasksCount.toString().separateNumbers3By3() ??
            totalStatistics.value.doneTasksCount.toString().separateNumbers3By3(),
        color: Colors.green,
        subtitle: '${s.tasks} ${s.completed}',
      ),
      StatCardValueEntity(
        icon: Icons.schedule_outlined,
        title: s.overdue,
        value:
            stat?.overdueTasksCount.toString().separateNumbers3By3() ??
            totalStatistics.value.overdueTasksCount.toString().separateNumbers3By3(),
        color: Colors.red,
        subtitle: s.overdueTasks,
      ),
      StatCardValueEntity(
        icon: Icons.alarm_off_outlined,
        title: s.unscheduled,
        value:
            stat?.withoutTimingTasksCount.toString().separateNumbers3By3() ??
            totalStatistics.value.withoutTimingTasksCount.toString().separateNumbers3By3(),
        color: Colors.grey,
        subtitle: s.unscheduledTasks,
      ),
      StatCardValueEntity(
        icon: Icons.timer_outlined,
        title: s.timeSpent,
        value: stat?.totalSeconds.toHoursMinutesSecondsFormat ?? totalStatistics.value.totalSeconds.toHoursMinutesSecondsFormat,
        color: Colors.deepPurple,
        subtitle: 'HH:MM:SS',
      ),
    ];
  }
}
