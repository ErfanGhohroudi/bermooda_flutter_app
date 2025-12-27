part of '../../../data.dart';

class ProjectUserStatisticsSummary extends Equatable {
  const ProjectUserStatisticsSummary({
    required this.userData,
    required this.totalTasksCount,
    required this.doneTasksCount,
    required this.runningTasksCount,
    required this.overdueTasksCount,
    required this.withoutTimingTasksCount,
    required this.totalSeconds,
  });

  final UserReadDto userData;
  final int totalTasksCount;
  final int doneTasksCount;
  final int runningTasksCount;
  final int overdueTasksCount;
  final int withoutTimingTasksCount;
  final int totalSeconds;

  factory ProjectUserStatisticsSummary.fromJson(final String str) =>
      ProjectUserStatisticsSummary.fromMap(json.decode(str));

  factory ProjectUserStatisticsSummary.fromMap(final Map<String, dynamic> json) =>
      ProjectUserStatisticsSummary(
        userData: UserReadDto.fromMap(json),
        totalTasksCount: json["all_task"] ?? 0,
        doneTasksCount: json["done_tasks"] ?? 0,
        runningTasksCount: json["running_tasks"] ?? 0,
        overdueTasksCount: json["overdue_tasks"] ?? 0,
        withoutTimingTasksCount: json["without_timing_task"] ?? 0,
        totalSeconds: json["total_seconds"] ?? 0,
      );

  @override
  List<Object?> get props => [
    userData,
    totalTasksCount,
    doneTasksCount,
    runningTasksCount,
    overdueTasksCount,
    withoutTimingTasksCount,
    totalSeconds,
  ];
}
