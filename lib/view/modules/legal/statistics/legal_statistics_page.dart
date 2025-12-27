import 'package:u/utilities.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'entities/stat_card_value_entity.dart';
import 'legal_statistics_controller.dart';

class LegalStatisticsPage extends StatefulWidget {
  const LegalStatisticsPage({
    required this.legalDepartment,
    super.key,
  });

  final LegalDepartmentReadDto legalDepartment;

  @override
  State<LegalStatisticsPage> createState() => _LegalStatisticsPageState();
}

class _LegalStatisticsPageState extends State<LegalStatisticsPage> with LegalStatisticsController {
  @override
  void initState() {
    initialController(legalDepartmentId: widget.legalDepartment.id ?? '0');
    super.initState();
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
                '${s.overallStatistics} (${widget.legalDepartment.title ?? "- -"})',
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
            childAspectRatio: 1.2,
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
              Text(stat.subtitle).bodyMedium(color: stat.color.withValues(alpha: 0.6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatisticsCard(final LegalUserStatisticsSummary stat) {
    final statCardValues = _getStatCardValues(stat: stat);

    return WCard(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اطلاعات کاربر
          Row(
            children: [
              // آواتار کاربر
              WCircleAvatar(
                size: 50,
                user: stat.userData,
              ),
              const SizedBox(width: 16),

              // اطلاعات کاربر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(stat.userData.fullName ?? '- -').titleMedium(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // آمار تفصیلی
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: statCardValues.map((final stat) => _buildStatItem(stat)).toList(),
          ),
        ],
      ),
    );
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
              ).bodyMedium(
                color: stat.color.withValues(alpha: 0.9),
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
              Text(
                stat.subtitle,
              ).bodySmall(color: stat.color.withValues(alpha: 0.6)),
            ],
          ),
        ],
      ),
    );
  }

  List<StatCardValueEntity> _getStatCardValues({final LegalUserStatisticsSummary? stat}) {
    final totalStat = stat?.total ?? totalStatistics.value.total;
    final runningStat = stat?.running ?? totalStatistics.value.running;
    final inProgressStat = stat?.inProgress ?? totalStatistics.value.inProgress;
    final successfulStat = stat?.successful ?? totalStatistics.value.successful;
    final delayedStat = stat?.delayed ?? totalStatistics.value.overdue;
    final contractsCount = stat?.contractsCount ?? totalStatistics.value.totalContracts;

    return [
      StatCardValueEntity(
        icon: Icons.assignment_outlined,
        title: s.totalCount,
        value: totalStat.total.toString().separateNumbers3By3(),
        color: Colors.blue,
        subtitle:
            '${s.followUp}: ${totalStat.tracking.toString().separateNumbers3By3()}'
            '\n'
            '${s.task}: ${totalStat.checklist.toString().separateNumbers3By3()}',
      ),
      StatCardValueEntity(
        icon: Icons.pending_outlined,
        title: s.pending,
        value: runningStat.total.toString().separateNumbers3By3(),
        color: Colors.orange,
        subtitle:
            '${s.followUp}: ${runningStat.tracking.toString().separateNumbers3By3()}'
            '\n'
            '${s.task}: ${runningStat.checklist.toString().separateNumbers3By3()}',
      ),
      StatCardValueEntity(
        icon: Icons.play_circle_outline,
        title: s.inProgress,
        value: inProgressStat.total.toString().separateNumbers3By3(),
        color: Colors.lightBlue,
        subtitle:
            '${s.followUp}: ${inProgressStat.tracking.toString().separateNumbers3By3()}'
            '\n'
            '${s.task}: ${inProgressStat.checklist.toString().separateNumbers3By3()}',
      ),
      StatCardValueEntity(
        icon: Icons.check_circle_outline,
        title: s.completed,
        value: successfulStat.total.toString().separateNumbers3By3(),
        color: Colors.green,
        subtitle:
            '${s.followUp}: ${successfulStat.tracking.toString().separateNumbers3By3()}'
            '\n'
            '${s.task}: ${successfulStat.checklist.toString().separateNumbers3By3()}',
      ),
      StatCardValueEntity(
        icon: Icons.schedule_outlined,
        title: s.overdue,
        value: delayedStat.total.toString().separateNumbers3By3(),
        color: Colors.red,
        subtitle:
            '${s.followUp}: ${delayedStat.tracking.toString().separateNumbers3By3()}'
            '\n'
            '${s.task}: ${delayedStat.checklist.toString().separateNumbers3By3()}',
      ),
      StatCardValueEntity(
        icon: Icons.description_outlined,
        title: s.contracts,
        value: contractsCount.toString().separateNumbers3By3(),
        color: Colors.purple,
        subtitle: s.totalContracts,
      ),
    ];
  }
}
