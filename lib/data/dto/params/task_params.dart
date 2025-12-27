part of '../../data.dart';

class TaskParams {
  TaskParams({
    this.subtasks,
    this.title,
    this.description,
    this.sectionId,
    this.projectId,
  });

  final List<SubtaskReadDto>? subtasks;
  final String? title;
  final String? description;
  final int? sectionId;
  final String? projectId;

  String toJson() => json.encode(removeNullEntries(toMap())!).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    "check_list_data": subtasks?.map((final e) => e.toMap()).toList(),
    "title": title,
    "description": description,
    "category_task_id": sectionId,
    "project_id": projectId?.toInt(),
  };
}
