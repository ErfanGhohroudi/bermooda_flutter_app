part of '../../../data.dart';

class TaskReadDto extends Equatable {
  const TaskReadDto({
    this.id,
    this.doneStatus = false,
    this.isDeleted = false,
    this.projectId,
    this.subtasks = const [],
    this.title,
    this.description,
    this.order,
    this.section,
    this.taskProgress,
  });

  final int? id;
  final bool doneStatus;
  final bool isDeleted;
  final String? projectId;
  final List<SubtaskReadDto> subtasks;
  final String? title;
  final String? description;
  final int? order;
  final ProjectSectionReadDto? section;
  final double? taskProgress;

  factory TaskReadDto.fromJson(final String str) => TaskReadDto.fromMap(json.decode(str));

  factory TaskReadDto.fromMap(final Map<String, dynamic> json) => TaskReadDto(
        id: json["id"],
        doneStatus: json["done_status"] ?? false,
        isDeleted: json["is_deleted"] ?? false,
        projectId: json["project_id_main"]?.toString(),
        subtasks: json["check_list"] == null ? [] : List<SubtaskReadDto>.from(json["check_list"]!.map((final x) => SubtaskReadDto.fromMap(x))),
        title: json["title"],
        description: json["description"],
        order: json["order"],
        section: json["category_task"] == null ? null : ProjectSectionReadDto.fromMap(json["category_task"]),
        taskProgress: json["task_progress"]?.toDouble(),
      );

  @override
  List<Object?> get props => [
        id,
        doneStatus,
        isDeleted,
        projectId,
        subtasks,
        title,
        description,
        order,
        section,
        taskProgress,
      ];
}
