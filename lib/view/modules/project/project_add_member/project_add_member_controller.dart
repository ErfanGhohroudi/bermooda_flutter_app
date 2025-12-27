import 'package:u/utilities.dart';

import '../../../../core/utils/enums/enums.dart';
import '../../../../data/data.dart';

mixin ProjectAddMemberController {
  late ProjectReadDto project;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProjectDatasource _projectDatasource = Get.find<ProjectDatasource>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = [];

  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    pageState.close();
    buttonState.close();
  }

  void onSubmit({required final Function(ProjectReadDto project) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        update(onResponse);
      },
    );
  }

  void update(final Function(ProjectReadDto project) onResponse) {
    final List<UserReadDto> list = [...project.members ?? [], ...selectedMembers];

    _projectDatasource.update(
      id: project.id,
      avatarId: project.avatar?.fileId,
      title: project.title ?? '',
      users: list,
      startDate: project.startDate,
      dueDate: project.dueDate,
      budget: project.budget,
      // currency: project.currency,
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

  void getMembers() {
    _memberDatasource.getAllMembers(
      perName: PermissionName.project,
      onResponse: (final response) {
        if (response.resultList != null) {
          if (project.members.isNullOrEmpty()) {
            members = response.resultList!;
          } else {
            members = response.resultList!.where((final e) => !project.members!.any((final m) => m.id == e.id)).toList();
          }
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
