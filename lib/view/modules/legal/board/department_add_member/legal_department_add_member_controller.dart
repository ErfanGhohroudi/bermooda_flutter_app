import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../departments/legal_department_list_controller.dart';
import '../legal_board_controller.dart';

mixin LegalDepartmentAddMemberController {
  late final LegalDepartmentReadDto department;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LegalDatasource _datasource = Get.find<LegalDatasource>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = [];

  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    pageState.close();
    buttonState.close();
  }

  void initialController(final LegalDepartmentReadDto department) {
    this.department = department;
    getMembers();
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        _update();
      },
    );
  }

  void _update() {
    final List<UserReadDto> list = [...department.members, ...selectedMembers];
    _datasource.update(
      id: department.id,
      title: department.title ?? '',
      avatar: MainFileReadDto(url: department.avatarUrl),
      memberIdList: list.map((final e) => e.id.toInt()).toList(),
      onResponse: (final response) {
        if (response.result != null) {
          if (Get.isRegistered<LegalBoardController>()) {
            Get.find<LegalBoardController>().department = response.result!;
          }
          if (Get.isRegistered<LegalDepartmentListController>()) {
            Get.find<LegalDepartmentListController>().updateDepartment(response.result!);
          }
        }
        buttonState.loaded();
        UNavigator.back();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }

  void getMembers() {
    _memberDatasource.getAllMembers(
      perName: PermissionName.legal,
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
