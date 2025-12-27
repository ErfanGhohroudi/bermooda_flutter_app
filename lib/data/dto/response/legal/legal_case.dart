part of '../../../data.dart';

class LegalCaseReadDto extends Equatable {
  const LegalCaseReadDto({
    required this.id,
    this.title,
    this.description,
    this.departmentId,
    this.contract,
    this.steps = const [],
    this.createdAt,
    this.taskItems = const [],
  });

  final int id;
  final String? title;
  final String? description;
  final int? departmentId;
  final ContractReadDto? contract;
  final List<LegalCaseStep> steps;
  final String? createdAt;
  final List<dynamic> taskItems;

  LegalCaseReadDto copyWith({
    final String? title,
    final String? description,
    final int? departmentId,
    final ContractReadDto? contract,
    final List<LegalCaseStep>? steps,
    final String? createdAt,
  }) {
    return LegalCaseReadDto(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      departmentId: departmentId ?? this.departmentId,
      contract: contract ?? this.contract,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
      taskItems: taskItems,
    );
  }

  factory LegalCaseReadDto.fromJson(final String str) => LegalCaseReadDto.fromMap(json.decode(str));

  factory LegalCaseReadDto.fromMap(final Map<String, dynamic> json) {
    List<dynamic> getTaskItems() {
      if (json['task_items'] != null && json['task_items'] is List) {
        final items = <dynamic>[];
        for (final item in json['task_items']) {
          if (item is Map<String, dynamic>) {
            final itemType = item['item_type']?.toString();
            if (itemType == 'tracking') {
              items.add(FollowUpReadDto.fromMap(item));
            } else if (itemType == 'checklist') {
              items.add(SubtaskReadDto.fromMap(item));
            }
          }
        }

        return items;
      } else {
        return [];
      }
    }

    return LegalCaseReadDto(
      id: json['id'] as int,
      title: json["title"],
      description: json["description"],
      departmentId: json["contract_board"] == null
          ? null
          : (json["contract_board"] is int ? json["contract_board"] as int : int.tryParse(json["contract_board"].toString())),
      contract: json["contract_data"] == null ? null : ContractReadDto.fromMap(json["contract_data"]),
      steps: json["case_steps"] == null
          ? []
          : List<LegalCaseStep>.from(json["case_steps"].map((final x) => LegalCaseStep.fromMap(x))),
      createdAt: json["contract_date"],
      taskItems: getTaskItems(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    departmentId,
    contract,
    steps,
    createdAt,
    taskItems,
  ];
}

class LegalCaseStep extends Equatable {
  const LegalCaseStep({
    required this.id,
    this.title,
    this.stepNumber,
    this.isCompleted = false,
  });

  final int id;
  final String? title;
  final int? stepNumber;
  final bool isCompleted;

  LegalCaseStep copyWith({
    final String? title,
    final int? stepNumber,
    final bool? isCompleted,
  }) {
    return LegalCaseStep(
      id: id,
      title: title ?? this.title,
      stepNumber: stepNumber ?? this.stepNumber,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory LegalCaseStep.fromJson(final String str) => LegalCaseStep.fromMap(json.decode(str));

  factory LegalCaseStep.fromMap(final Map<String, dynamic> json) => LegalCaseStep(
    id: json['id'] as int,
    title: json["title"],
    stepNumber: json["step_number"],
    isCompleted: (json["is_completed"] as bool?) ?? false,
  );

  @override
  List<Object?> get props => [id, title, stepNumber, isCompleted];
}
