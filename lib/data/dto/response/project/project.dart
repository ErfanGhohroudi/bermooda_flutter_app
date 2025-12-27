part of '../../../data.dart';

class ProjectReadDto extends Equatable {
  const ProjectReadDto({
    this.id,
    this.title,
    this.avatar,
    this.sections,
    this.members,
    this.projectStatus,
    this.progress = 0,
    this.startDate,
    this.dueDate,
    this.budget,
    // this.currency,
  });

  final String? id;
  final String? title;
  final MainFileReadDto? avatar;
  final List<ProjectSectionReadDto>? sections;
  final List<UserReadDto>? members;
  final ProjectStatus? projectStatus;
  final int progress;
  final String? startDate;
  final String? dueDate;
  final String? budget;
  // final CurrencyUnitReadDto? currency;

  ProjectReadDto copyWith({
    final String? title,
    final MainFileReadDto? avatar,
    final List<ProjectSectionReadDto>? sections,
    final List<UserReadDto>? members,
    final ProjectStatus? projectStatus,
    final int? progress,
    final String? startDate,
    final String? dueDate,
    final String? budget,
    // final CurrencyUnitReadDto? currency,
  }) =>
      ProjectReadDto(
        id: id,
        title: title ?? this.title,
        avatar: avatar ?? this.avatar,
        sections: sections ?? this.sections,
        members: members ?? this.members,
        projectStatus: projectStatus ?? this.projectStatus,
        startDate: startDate ?? this.startDate,
        dueDate: dueDate ?? this.dueDate,
        budget: budget ?? this.budget,
        // currency: currency ?? this.currency,
      );

  factory ProjectReadDto.fromJson(final String str) => ProjectReadDto.fromMap(json.decode(str));

  factory ProjectReadDto.fromMap(final Map<String, dynamic> json) => ProjectReadDto(
        id: json["id"]?.toString(),
        title: json["title"],
        avatar: json["avatar_url"] == null || json["avatar_url"] is! Map<String, dynamic> ? null : MainFileReadDto.fromMap(json["avatar_url"]),
        sections: json["category_project"] == null ? [] : List<ProjectSectionReadDto>.from(json["category_project"]!.map((final x) => ProjectSectionReadDto.fromMap(x))),
        members: json["members"] == null ? [] : List<UserReadDto>.from(json["members"]!.map((final x) => UserReadDto.fromMap(x))),
        projectStatus: json["project_status"] == null ? null : ProjectStatus.fromMap(json["project_status"]),
        progress: json["project_progress"]?.round() ?? 0,
        startDate: json["start_date"],
        dueDate: json["due_date"],
        budget: json["cost"]?.toString(),
        // currency: json["currency"] == null ? null : CurrencyUnitReadDto.fromMap(json["currency"]),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        avatar,
        sections,
        members,
        projectStatus,
        progress,
        startDate,
        dueDate,
        budget,
        // currency,
      ];
}

class ProjectStatus extends Equatable {
  const ProjectStatus({
    this.completedTaskCount,
    this.possessingTaskCount,
    this.overdueTaskCount,
    this.allTaskCount,
    this.progressPercentage,
  });

  final int? completedTaskCount;
  final int? possessingTaskCount;
  final int? overdueTaskCount;
  final int? allTaskCount;
  final int? progressPercentage;

  factory ProjectStatus.fromJson(final String str) => ProjectStatus.fromMap(json.decode(str));

  factory ProjectStatus.fromMap(final Map<String, dynamic> json) => ProjectStatus(
        completedTaskCount: json["completed_task_count"],
        possessingTaskCount: json["possessing_task_count"],
        overdueTaskCount: json["overdue_task_count"],
        allTaskCount: json["all_task_count"],
        progressPercentage: json["progress_percentage"],
      );

  @override
  List<Object?> get props => [completedTaskCount, possessingTaskCount, overdueTaskCount, allTaskCount, progressPercentage];
}
