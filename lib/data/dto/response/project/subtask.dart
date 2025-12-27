part of '../../../data.dart';

enum SubtaskDataSourceType {
  project,
  legal;

  bool get isLegal => this == SubtaskDataSourceType.legal;

  bool get isProject => this == SubtaskDataSourceType.project;
}

class SubtaskReadDto extends Equatable {
  const SubtaskReadDto({
    required this.id,
    this.slug,
    this.title,
    this.isCompleted = false,
    this.dateToStart,
    this.timeToStart,
    this.dateToEnd,
    this.timeToEnd,
    this.links = const [],
    this.files = const [],
    this.labels = const [],
    this.responsibleForDoing,
    this.isDelayed = false,
    this.timer,
    this.progress,
    this.isArchived = false,
    this.projectId,
    this.taskData,
    this.legalDepartmentId,
    this.legalCaseId,
    this.legalCaseData,

    ///
    this.taskId,
  });

  final String id;
  final String? slug;
  final String? title;
  final bool isCompleted;
  final String? dateToStart; // YYYY/MM/DD Jalali
  final String? timeToStart; // HH:MM
  final String? dateToEnd; // YYYY/MM/DD Jalali
  final String? timeToEnd; // HH:MM
  final List<LinkReadDto> links;
  final List<MainFileReadDto> files;
  final List<LabelReadDto> labels;
  final UserReadDto? responsibleForDoing;
  final bool isDelayed;
  final TimerReadDto? timer;
  final int? progress;
  final bool isArchived;

  /// Project Subtask Fields
  final String? projectId;
  final TaskData? taskData;

  /// Legal Subtask Fields
  final String? legalDepartmentId;
  final int? legalCaseId;
  final LegalCaseData? legalCaseData;

  /// just for toMap() params
  final int? taskId;

  String? get mainSourceId => projectId ?? legalDepartmentId;

  SubtaskDataSourceType? get dataSourceType {
    if (taskData != null || projectId != null || taskId != null) {
      return SubtaskDataSourceType.project;
    } else if (legalCaseData != null || legalCaseId != null) {
      return SubtaskDataSourceType.legal;
    }
    return null;
  }

  factory SubtaskReadDto.fromJson(final String str) => SubtaskReadDto.fromMap(json.decode(str));

  factory SubtaskReadDto.fromMap(final Map<String, dynamic> json) {
    return SubtaskReadDto(
      id: json["id"].toString(),
      slug: json["slug"],
      title: json["title"]?.trim(),
      isCompleted: json["status"] ?? json["is_completed"] ?? false,
      dateToStart: json["date_to_start"] != null && json["date_to_start"].contains('/')
          ? json["date_to_start"]
          : DateTime.tryParse(json["date_to_start"] ?? '')?.toJalali().formatCompactDate(),
      timeToStart: json["time_to_start"],
      dateToEnd: json["date_to_end"] != null && json["date_to_end"].contains('/')
          ? json["date_to_end"]
          : DateTime.tryParse(json["date_to_end"] ?? '')?.toJalali().formatCompactDate(),
      timeToEnd: json["time_to_end"],
      links: json["links"] == null ? [] : List<LinkReadDto>.from(json["links"]!.map((final x) => LinkReadDto.fromMap(x))),
      files: json["file"] != null || json["files"] != null
          ? List<MainFileReadDto>.from((json["file"] ?? json["files"])!.map((final x) => MainFileReadDto.fromMap(x)))
          : [],
      labels: json["label"] == null ? [] : List<LabelReadDto>.from(json["label"]!.map((final x) => LabelReadDto.fromMap(x))),
      responsibleForDoing: json["responsible_for_doing"] != null || json["responsible_detail"] != null
          ? UserReadDto.fromMap(json["responsible_for_doing"] ?? json["responsible_detail"])
          : null,
      isDelayed: json["is_delayed"] ?? false,
      timer: json["timer"] == null ? null : TimerReadDto.fromMap(json["timer"]),
      progress: json["progress"],
      isArchived: json["is_archived"] ?? false,
      // Project Subtask Fields
      projectId: json["project_id_main"]?.toString(),
      taskData: json["task_data"] == null ? null : TaskData.fromMap(json["task_data"]),
      // Legal Subtask Fields
      legalDepartmentId: json["contract_board_id"]?.toString(),
      legalCaseId: json["contract_case"],
      legalCaseData: json["contract_case_data"] == null ? null : LegalCaseData.fromMap(json["contract_case_data"]),
      // taskId is just for creating subtask
    );
  }

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (dataSourceType?.isProject == true) "task_id": taskId,
      if (dataSourceType?.isLegal == true) "contract_case_id": legalCaseId,
      "title": title?.trim(),
      if (dataSourceType?.isProject == true) "responsible_for_doing_id": responsibleForDoing?.id.numericOnly().toInt(),
      if (dataSourceType?.isLegal == true) "responsible_id": responsibleForDoing?.id.numericOnly().toInt(),
      "date_to_start": dateToStart,
      "time_to_start": timeToStart,
      "date_to_end": dateToEnd,
      "time_to_end": timeToEnd,
      "label_id_list": labels.map((final e) => e.id).whereType<int>().toList(),
      "link_list": links.map((final e) => e.link).whereType<String>().toList(),
      "file_id_list": files.map((final e) => e.fileId).whereType<int>().toList(),
      "difficulty": 1,
    };
  }

  @override
  List<Object?> get props =>
      [
        slug,
        title,
        isCompleted,
        dateToStart,
        timeToStart,
        dateToEnd,
        timeToEnd,
        links,
        files,
        labels,
        responsibleForDoing,
        isDelayed,
        timer,
        taskId,
        progress,
        isArchived,
        projectId,
        taskData,
        legalDepartmentId,
        legalCaseId,
        legalCaseData,
      ];
}

class TaskData extends TaskReadDto {
  const TaskData({
    super.id,
    super.title,
    super.projectId,
    super.doneStatus = false,
    super.isDeleted = false,
  });

  factory TaskData.fromJson(final String str) => TaskData.fromMap(json.decode(str));

  factory TaskData.fromMap(final Map<String, dynamic> json) =>
      TaskData(
        id: json["id"],
        title: json["title"],
        doneStatus: json["done_status"] ?? false,
        projectId: json["project_id"]?.toString(),
        isDeleted: json["is_deleted"] ?? false,
      );

  @override
  List<Object?> get props =>
      [
        id,
        title,
        projectId,
        doneStatus,
        isDeleted,
      ];
}

class TimerReadDto extends Equatable {
  const TimerReadDto({
    this.id,
    this.status,
    this.isDone = false,
    this.elapsedSeconds = 0,
    this.slug,
  });

  final int? id;
  final TimerStatus? status;
  final bool isDone;
  final int elapsedSeconds;

  // just for Crm Follow-up
  final String? slug;

  TimerReadDto copyWith({
    final int? id,
    final TimerStatus? status,
    final bool? isDone,
    final int? elapsedSeconds,
    final String? slug,
  }) {
    return TimerReadDto(
      id: id ?? this.id,
      status: status ?? this.status,
      isDone: isDone ?? this.isDone,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      slug: slug ?? this.slug,
    );
  }

  factory TimerReadDto.fromJson(final String str) => TimerReadDto.fromMap(json.decode(str));

  factory TimerReadDto.fromMap(final Map<String, dynamic> json) =>
      TimerReadDto(
        id: json["id"],
        status: json["status"] == null
            ? null
            : TimerStatus.values.firstWhereOrNull((final e) => e.name == json["status"]?.toString().toLowerCase()),
        isDone: json["is_done"] ?? false,
        elapsedSeconds: json["get_elapsed_seconds"] ?? 0,
        slug: json["slug"], // for crm followup
      );

  @override
  List<Object?> get props => [id, status, isDone, elapsedSeconds, slug];
}

class LinkReadDto extends Equatable {
  const LinkReadDto({
    this.slug,
    this.link,
  });

  final String? slug;
  final String? link;

  factory LinkReadDto.fromJson(final String str) => LinkReadDto.fromMap(json.decode(str));

  factory LinkReadDto.fromMap(final Map<String, dynamic> json) =>
      LinkReadDto(
        slug: json["slug"],
        link: json["link"],
      );

  @override
  List<Object?> get props => [slug, link];
}
