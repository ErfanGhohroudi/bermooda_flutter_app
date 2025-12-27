import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';

mixin DepartmentAddMemberController {
  late final HRDepartmentReadDto department;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final HumanResourceDatasource _hrFolderDatasource = Get.find<HumanResourceDatasource>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = [];

  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    pageState.close();
    buttonState.close();
  }

  void initialController(final HRDepartmentReadDto department) {
    this.department = department;
    getMembers();
  }

  void onSubmit({required final Function(HRDepartmentReadDto department) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        _update(onResponse);
      },
    );
  }

  void _update(final Function(HRDepartmentReadDto department) onResponse) {
    final List<UserReadDto> list = [...department.members, ...selectedMembers];
    _hrFolderDatasource.update(
      slug: department.slug,
      title: department.title ?? '',
      avatarId: department.avatar?.fileId,
      memberIdList: list.map((final e) => e.id.toInt()).toList(),
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
      perName: PermissionName.humanResources,
      onResponse: (final response) {
        if (response.resultList != null) {
          if (department.members.isEmpty) {
            members = response.resultList!;
          } else {
            members = response.resultList!.where((final e) => !department.members.any((final m) => m.id == e.id)).toList();
          }
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
