import 'package:u/utilities.dart';

import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../data/data.dart';

mixin CreateUpdateSubtaskController {
  /// projectId or legalDepartmentId
  late final String mainSourceId;

  late final SubtaskDataSourceType _dataSourceType;

  /// taskId or legalCaseId required for create
  int? sourceId;

  final SubtaskDatasource _datasource = Get.find<SubtaskDatasource>();
  final RxList<UserReadDto> members = <UserReadDto>[].obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final Rx<PageState> membersState = PageState.loaded.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SubtaskReadDto? subtask;
  bool isEditingMod = false;

  final TextEditingController titleController = TextEditingController();
  UserReadDto? memberAssignee;
  RangeDatePickerViewModel dateTimes = RangeDatePickerViewModel();
  List<LabelReadDto> selectedLabels = [];
  List<LinkReadDto> links = [];
  List<MainFileReadDto> files = [];
  bool isUploadingFile = false;

  LabelDataSourceType get labelDataSourceType => switch (_dataSourceType) {
    SubtaskDataSourceType.project => LabelDataSourceType.project,
    SubtaskDataSourceType.legal => LabelDataSourceType.legal,
  };


  void initialController({
    required final SubtaskDataSourceType dataSourceType,
    required final int? sourceId,
    required final String mainSourceId,
    required final SubtaskReadDto? subtask,
  }) {
    _dataSourceType = dataSourceType;
    this.sourceId = sourceId;
    this.mainSourceId = mainSourceId;
    this.subtask = subtask;
    isEditingMod = subtask != null;
    if (isEditingMod) {
      setValues(subtask!);
    }
    getSourceMembers();
  }

  void disposeItems() {
    members.close();
    buttonState.close();
    membersState.close();
    titleController.dispose();
  }

  void setValues(final SubtaskReadDto model) {
    titleController.text = model.title ?? '';
    memberAssignee = model.responsibleForDoing;
    selectedLabels.assignAll(model.labels);
    links = model.links;
    files = model.files;
    dateTimes = dateTimes.copyWith(
      startDate: model.dateToStart.isNullOrEmpty() ? null : model.dateToStart,
      startTime: model.timeToStart.isNullOrEmpty() ? null : model.timeToStart,
      endDate: model.dateToEnd.isNullOrEmpty() ? null : model.dateToEnd,
      dueTime: model.timeToEnd.isNullOrEmpty() ? null : model.timeToEnd,
    );
    // dateTimes.startDate = model.dateToStart.isNullOrEmpty() ? null : model.dateToStart;
    // dateTimes.startTime = model.timeToStart.isNullOrEmpty() ? null : model.timeToStart;
    // dateTimes.endDate = model.dateToEnd.isNullOrEmpty() ? null : model.dateToEnd;
    // dateTimes.dueTime = model.timeToEnd.isNullOrEmpty() ? null : model.timeToEnd;
  }

  void callApi({required final Function(SubtaskReadDto model) action}) {
    WImageFiles.checkFileUploading(
      isUploadingFile: isUploadingFile,
      action: () {
        validateForm(
          key: formKey,
          action: () {
            if (isEditingMod) {
              update(action: action);
            } else {
              create(action: action);
            }
          },
        );
      },
    );
  }

  SubtaskReadDto getModel() {
    final model = SubtaskReadDto(
      taskId: _dataSourceType.isProject ? sourceId : null,
      legalCaseId: _dataSourceType.isLegal ? sourceId : null,
      id: '',
      title: titleController.text.trim(),
      responsibleForDoing: memberAssignee,
      dateToStart: dateTimes.startDate,
      timeToStart: dateTimes.startTime,
      dateToEnd: dateTimes.endDate,
      timeToEnd: dateTimes.dueTime,
      labels: selectedLabels,
      timer: const TimerReadDto(elapsedSeconds: 0),
      links: links,
      files: files,
    );

    return model;
  }

  void create({required final Function(SubtaskReadDto model) action}) {
    buttonState.loading();
    if (sourceId == null) {
      action(getModel());
      buttonState.loaded();
    } else {
      _datasource.create(
        dataSourceType: _dataSourceType,
        dto: getModel(),
        onResponse: (final response) {
          if (buttonState.subject.isClosed) return;
          action(response.result!);
          buttonState.loaded();
        },
        onError: (final errorResponse) => buttonState.loaded(),
        withRetry: true,
      );
    }
  }

  void update({required final Function(SubtaskReadDto model) action}) {
    buttonState.loading();
    if (subtask == null) {
      action(getModel());
      buttonState.loaded();
    } else {
      _datasource.update(
        dataSourceType: _dataSourceType,
        id: subtask?.id,
        dto: getModel(),
        onResponse: (final response) {
          if (buttonState.subject.isClosed) return;
          action(response.result!);
          buttonState.loaded();
        },
        onError: (final errorResponse) => buttonState.loaded(),
        withRetry: true,
      );
    }
  }

  void getSourceMembers() {
    final MemberDatasource datasource = Get.find<MemberDatasource>();
    membersState.loading();
    datasource.getSourceMembers(
      sourceType: switch (_dataSourceType) {
        SubtaskDataSourceType.project => MemberSourceType.project,
        SubtaskDataSourceType.legal => MemberSourceType.legalDepartment,
      },
      sourceId: mainSourceId,
      onResponse: (final response) {
        if (members.subject.isClosed) return;
        members(response.resultList ?? []);
        memberAssignee = members.firstWhereOrNull((final member) => member.id == memberAssignee?.id);
        membersState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
