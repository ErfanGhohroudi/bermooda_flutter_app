import 'package:u/utilities.dart';

enum WorkshiftModeStatus {
  creating,
  updating,
  created,
  updated;

  bool get isCreating => this == WorkshiftModeStatus.creating;

  bool get isUpdating => this == WorkshiftModeStatus.updating;

  bool get isCreated => this == WorkshiftModeStatus.created;

  bool get isUpdated => this == WorkshiftModeStatus.updated;
}

extension WorkshiftCreateUpdateModeStateExtension on Rx<WorkshiftModeStatus> {
  WorkshiftModeStatus creating() => this(WorkshiftModeStatus.creating);

  WorkshiftModeStatus updating() => this(WorkshiftModeStatus.updating);

  WorkshiftModeStatus created() => this(WorkshiftModeStatus.created);

  WorkshiftModeStatus updated() => this(WorkshiftModeStatus.updated);
}
