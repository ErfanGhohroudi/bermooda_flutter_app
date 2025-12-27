import 'package:u/utilities.dart';

import '../../../../../core/widgets/image_files.dart';
import '../../../../../data/data.dart';
import '../../create_update/entity/project_settings_entity.dart';

mixin ProjectCreateUpdateController {
  ProjectReadDto? project;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  final Rx<PageState> buttonState = PageState.loaded.obs;

  // final SubscriptionService _subService = Get.find<SubscriptionService>();

  MainFileReadDto? avatar;
  final TextEditingController titleController = TextEditingController();
  bool isUploadingFile = false;
  List<UserReadDto> selectedMembers = [];
  ProjectSettingsEntity settingsParameters = const ProjectSettingsEntity();

  // bool get haveAdvancePlan => _subService.subscriptions.getByType(SubscriptionType.project)?.type == SubscriptionType.;

  void disposeItems() {
    buttonState.close();
    titleController.dispose();
  }

  void setValues() {
    avatar = project?.avatar?.fileId != null ? project?.avatar : null;
    titleController.text = project?.title ?? '';
    selectedMembers.assignAll(project?.members ?? selectedMembers);
    settingsParameters = ProjectSettingsEntity(
      startDate: project?.startDate,
      dueDate: project?.dueDate,
      budget: project?.budget,
      // currency: project?.currency,
    );
  }

  void onSubmit({required final Function(ProjectReadDto project) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: isUploadingFile,
          action: () {
            buttonState.loading();
            if (project == null) {
              create(onResponse);
            } else {
              update(onResponse);
            }
          },
        );
      },
    );
  }

  void create(final Function(ProjectReadDto project) onResponse) {
    _projectDatasource.create(
      avatarId: avatar?.fileId,
      title: titleController.text,
      users: selectedMembers,
      startDate: settingsParameters.startDate,
      dueDate: settingsParameters.dueDate,
      budget: settingsParameters.budget,
      // currency: settingsParameters.currency,
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
        buttonState.loaded();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }

  void update(final Function(ProjectReadDto project) onResponse) {
    _projectDatasource.update(
      id: project?.id,
      avatarId: avatar?.fileId,
      title: titleController.text,
      users: selectedMembers,
      startDate: settingsParameters.startDate,
      dueDate: settingsParameters.dueDate,
      budget: settingsParameters.budget,
      // currency: settingsParameters.currency,
      onResponse: (final response) {
        if (response.result != null) {
          onResponse(response.result!);
        }
        buttonState.loaded();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }
}
