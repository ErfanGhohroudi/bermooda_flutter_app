part of '../../../data.dart';

class ProjectStatisticsSummary extends Equatable {
  const ProjectStatisticsSummary({
    required this.totalTasksCount,
    required this.doneTasksCount,
    required this.runningTasksCount,
    required this.overdueTasksCount,
    required this.withoutTimingTasksCount,
    required this.totalSeconds,
  });

  final int totalTasksCount;
  final int doneTasksCount;
  final int runningTasksCount;
  final int overdueTasksCount;
  final int withoutTimingTasksCount;
  final int totalSeconds;

  factory ProjectStatisticsSummary.fromJson(final String str) =>
      ProjectStatisticsSummary.fromMap(json.decode(str));

  factory ProjectStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      ProjectStatisticsSummary(
        totalTasksCount: json["all_tasks"] ?? 0,
        doneTasksCount: json["completed_tasks"] ?? 0,
        runningTasksCount: json["running_tasks"] ?? 0,
        overdueTasksCount: json["overdue_tasks"] ?? 0,
        withoutTimingTasksCount: json["unscheduled_tasks"] ?? 0,
        totalSeconds: json["total_seconds"] ?? 0,
      );

  @override
  List<Object?> get props => [
    totalTasksCount,
    doneTasksCount,
    runningTasksCount,
    overdueTasksCount,
    withoutTimingTasksCount,
    totalSeconds,
  ];
}
