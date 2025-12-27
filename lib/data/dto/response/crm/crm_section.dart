part of '../../../data.dart';

class CrmSectionReadDto {
  CrmSectionReadDto({
    this.id,
    this.title,
    this.colorCode,
    this.labelStep,
    this.icon,
    this.steps,
  });

  int? id;
  String? title;
  String? colorCode;
  LabelStepReadDto? labelStep;
  MainFileReadDto? icon;
  List<StepReadDto>? steps;

  factory CrmSectionReadDto.fromJson(final String str) => CrmSectionReadDto.fromMap(json.decode(str));

  factory CrmSectionReadDto.fromMap(final Map<String, dynamic> json) => CrmSectionReadDto(
        id: json["id"] ?? json["label_id"],
        title: json["title"],
        colorCode: json["color_code"] ?? json["color"],
        labelStep: json["label_step"] == null ? null : LabelStepReadDto.fromMap(json["label_step"]),
        icon: json["icon"] == null ? null : MainFileReadDto.fromMap(json["icon"]),
        steps: json["steps"] == null ? [] : List<StepReadDto>.from(json["steps"]!.map((final x) => StepReadDto.fromMap(x))),
      );
}

class LabelStepReadDto {
  LabelStepReadDto({
    this.id,
    this.steps,
  });

  int? id;
  List<StepReadDto>? steps;

  factory LabelStepReadDto.fromJson(final String str) => LabelStepReadDto.fromMap(json.decode(str));

  factory LabelStepReadDto.fromMap(final Map<String, dynamic> json) => LabelStepReadDto(
    id: json["id"],
    steps: json["steps"] == null ? [] : List<StepReadDto>.from(json["steps"]!.map((final x) => StepReadDto.fromMap(x))),
  );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
    "id": id,
    "steps": steps == null ? [] : List<dynamic>.from(steps!.map((final x) => x.toMap())),
  };
}

class StepReadDto {
  StepReadDto({
    this.id,
    this.title,
    this.step,
  });

  int? id;
  String? title;
  int? step;

  factory StepReadDto.fromJson(final String str) => StepReadDto.fromMap(json.decode(str));

  factory StepReadDto.fromMap(final Map<String, dynamic> json) => StepReadDto(
    id: json["id"],
    title: json["title"],
    step: json["step"],
  );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
    "id": id,
    "title": title,
    "step": step,
  };
}
