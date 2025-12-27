import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';
import 'hr_statistics_controller.dart';

/// وضعیت عملکرد کارشناس
/// این کلاس شامل اطلاعات مربوط به وضعیت عملکرد هر کارشناس است
class PerformanceStatus {
  const PerformanceStatus({
    required this.title,
    required this.color,
  });

  final String title; // عنوان وضعیت (عالی، خوب، متوسط، نیاز به بهبود)
  final Color color; // رنگ مربوط به وضعیت
}

class HrStatisticsPage extends StatefulWidget {
  const HrStatisticsPage({
    required this.department,
    super.key,
  });

  final HRDepartmentReadDto department;

  @override
  State<HrStatisticsPage> createState() => _HrStatisticsPageState();
}

class _HrStatisticsPageState extends State<HrStatisticsPage> with HRStatisticsController {
  @override
  void initState() {
    super.initState();
    initialController(department: widget.department);
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
              Obx(
                () {
                  if (pageState.isLoading() || pageState.isInitial()) {
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
                                const UImage(AppIcons.groupOutline, size: 20),
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
                                return _buildUserStatisticsCard(stat).marginOnly(bottom: (index + 1) == userStatisticsSummaries.length && isAtEnd ? 70 : 0);
                              },
                            ),
                          )
                        else
                          const SliverToBoxAdapter(child: Center(child: WEmptyWidget())),
                      ],
                    ),
                  );
                },
              ).expanded(),
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
    // محاسبه آمار کلی از تمام کارشناسان
    final totalUsers = userStatisticsSummaries.length.toString().separateNumbers3By3();
    final totalRequests = totalStatistics.value.totalRequestCount.toString().separateNumbers3By3();
    final totalPending = totalStatistics.value.pendingReviewCount.toString().separateNumbers3By3();
    final totalClosed = totalStatistics.value.closedRequestCount.toString().separateNumbers3By3();
    final totalDelayed = totalStatistics.value.delayedRequestCount.toString().separateNumbers3By3();
    final totalUnassigned = totalStatistics.value.unassignedRequestsCount.toString().separateNumbers3By3();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // عنوان بخش آمار کلی
          Row(
            children: [
              const UImage(AppIcons.statisticsOutline, size: 20),
              const SizedBox(width: 8),
              Text(
                '${s.overallStatistics} (${widget.department.title ?? "- -"})',
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
            children: [
              _buildOverallStatCard(
                icon: Icons.people_outline,
                title: 'تعداد کارشناسان',
                value: totalUsers,
                color: AppColors.blueLink,
                subtitle: 'کارشناس فعال',
              ),
              _buildOverallStatCard(
                icon: Icons.assignment_outlined,
                title: 'کل درخواست‌ها',
                value: totalRequests,
                color: AppColors.purple,
                subtitle: 'درخواست ثبت شده',
              ),
              _buildOverallStatCard(
                icon: Icons.pending_outlined,
                title: 'در انتظار بررسی',
                value: totalPending,
                color: AppColors.orange,
                subtitle: 'نیاز به بررسی',
              ),
              _buildOverallStatCard(
                icon: Icons.check_circle_outline,
                title: 'بسته شده',
                value: totalClosed,
                color: AppColors.green,
                subtitle: 'تکمیل شده',
              ),
              _buildOverallStatCard(
                icon: Icons.schedule_outlined,
                title: 'تأخیر دار',
                value: totalDelayed,
                color: AppColors.red,
                subtitle: 'نیاز به پیگیری',
              ),
              _buildOverallStatCard(
                icon: Icons.cancel_outlined,
                title: 'اختصاص داده نشده',
                value: totalUnassigned,
                color: Colors.grey,
                subtitle: 'نیاز به بررسی کننده',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatCard({
    required final IconData icon,
    required final String title,
    required final String value,
    required final Color color,
    required final String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
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
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title).titleMedium(color: color.withValues(alpha: 0.8)).bold(),
              Text(
                subtitle,
                maxLines: 1,
              ).bodyMedium(
                color: color.withValues(alpha: 0.6),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatisticsCard(final HRUserStatisticsSummary stat) {
    // محاسبه درصد موفقیت کارشناس
    final successRate = stat.totalRequestCount > 0 ? ((stat.closedRequestCount / stat.totalRequestCount) * 100).round() : 0;

    // تعیین وضعیت عملکرد کارشناس
    final performanceStatus = _getPerformanceStatus(stat);

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

          // آمار تفصیلی درخواست‌ها
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: [
              _buildStatItem(
                icon: Icons.assignment_outlined,
                title: 'کل درخواست‌ها',
                value: stat.totalRequestCount.toString(),
                color: Colors.blue,
                subtitle: 'مجموع درخواست‌ها',
              ),
              _buildStatItem(
                icon: Icons.pending_outlined,
                title: 'در انتظار بررسی',
                value: stat.pendingReviewCount.toString(),
                color: Colors.orange,
                subtitle: 'نیاز به بررسی',
              ),
              _buildStatItem(
                icon: Icons.check_circle_outline,
                title: 'بسته شده',
                value: stat.closedRequestCount.toString(),
                color: Colors.green,
                subtitle: 'تکمیل شده',
              ),
              _buildStatItem(
                icon: Icons.schedule_outlined,
                title: 'تأخیر دار',
                value: stat.delayedRequestCount.toString(),
                color: Colors.red,
                subtitle: 'نیاز به پیگیری',
              ),
            ],
          ),

          // درخواست‌های رد شده (اگر وجود داشته باشد)
          if (stat.rejectedRequestsCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'درخواست‌های رد شده: ${stat.rejectedRequestsCount}',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// تعیین وضعیت عملکرد کارشناس بر اساس آمار درخواست‌ها
  /// این متد وضعیت عملکرد کارشناس را بر اساس نسبت درخواست‌های موفق و تأخیر دار تعیین می‌کند
  PerformanceStatus _getPerformanceStatus(final HRUserStatisticsSummary stat) {
    if (stat.totalRequestCount == 0) {
      return PerformanceStatus(
        title: s.noActivity,
        color: Colors.grey,
      );
    }

    final successRate = (stat.closedRequestCount / stat.totalRequestCount) * 100;
    final delayedRate = (stat.delayedRequestCount / stat.totalRequestCount) * 100;

    if (successRate >= 80 && delayedRate <= 10) {
      return PerformanceStatus(
        title: s.excellent,
        color: AppColors.green,
      );
    } else if (successRate >= 60 && delayedRate <= 20) {
      return PerformanceStatus(
        title: s.good,
        color: AppColors.blue,
      );
    } else if (successRate >= 40 && delayedRate <= 30) {
      return PerformanceStatus(
        title: s.fair,
        color: AppColors.orange,
      );
    } else {
      return PerformanceStatus(
        title: s.needsImprovement,
        color: AppColors.red,
      );
    }
  }

  Widget _buildStatItem({
    required final IconData icon,
    required final String title,
    required final String value,
    required final Color color,
    final String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // آیکون و مقدار
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(value).bodyMedium(fontSize: 20, color: color).bold(),
            ],
          ),

          const SizedBox(height: 8),

          // عنوان و زیرعنوان
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).bodyMedium(color: color.withValues(alpha: 0.9)).bold(),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).bodySmall(color: color.withValues(alpha: 0.6)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
