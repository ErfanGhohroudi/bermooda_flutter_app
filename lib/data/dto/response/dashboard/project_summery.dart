part of '../../../data.dart';

class ProjectSummeryReadDto extends Equatable {
  const ProjectSummeryReadDto({
    this.activeProjects = 0,
    this.averageProjectProgress = 0,
    this.delayedProjectCount = 0,
    this.uncompletedSubtasks = 0,
    this.completedSubtasks = 0,
    this.delayedSubtasks = 0,
  });

  final int activeProjects;
  final double averageProjectProgress;
  final int delayedProjectCount;
  final int uncompletedSubtasks;
  final int completedSubtasks;
  final int delayedSubtasks;

  factory ProjectSummeryReadDto.fromJson(final String str) => ProjectSummeryReadDto.fromMap(json.decode(str));

  factory ProjectSummeryReadDto.fromMap(final Map<String, dynamic> json) => ProjectSummeryReadDto(
        activeProjects: json["active_projects"] ?? 0,
        averageProjectProgress: json["average_project_progress"]?.toDouble() ?? 0,
        delayedProjectCount: json["delayed_project_count"] ?? 0,
        uncompletedSubtasks: json["un_completed_check_lists"] ?? 0,
        completedSubtasks: json["completed_check_lists"] ?? 0,
        delayedSubtasks: json["delayed_check_list"] ?? 0,
      );

  @override
  List<Object?> get props => [
        activeProjects,
        averageProjectProgress,
        delayedProjectCount,
        uncompletedSubtasks,
        completedSubtasks,
        delayedSubtasks,
      ];
}
