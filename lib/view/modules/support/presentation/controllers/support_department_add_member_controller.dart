import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../../../../data/data.dart';
import '../../domain/entities/support_department.dart';
import '../../domain/usecases/get_members.dart';
import '../../domain/usecases/update_support_department.dart';
import 'department_list_controller.dart';

mixin SupportDepartmentAddMemberController {
  late SupportDepartment department;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UpdateSupportDepartmentUseCase _updateDepartmentUseCase = Get.find();
  final GetMembersUseCase _getMemberUseCase = Get.find();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = [];

  List<UserReadDto> selectedMembers = [];

  void disposeItems() {
    pageState.close();
    buttonState.close();
  }

  void initialController(final SupportDepartment department) {
    this.department = department;
    getMembers();
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        update();
      },
    );
  }

  void update() async {
    final List<UserReadDto> list = [...department.members, ...selectedMembers];

    try {
      final updatedDepartment = await _updateDepartmentUseCase(
        id: department.id,
        avatarId: department.avatar?.fileId,
        title: department.title,
        members: list,
      );

      if(Get.isRegistered<SupportDepartmentListController>()) {
        Get.find<SupportDepartmentListController>().updateItem(updatedDepartment);
      }
      buttonState.loaded();
      AppNavigator.back(result: updatedDepartment);
    } catch(e) {
      buttonState.loaded();
    }
  }

  void getMembers() async {
    try {
      final membersList = await _getMemberUseCase();
      if (department.members.isNullOrEmpty()) {
        members = membersList;
      } else {
        members = membersList.where((final e) => !department.members.any((final m) => m.id == e.id)).toList();
      }
      pageState.loaded();
    } catch(e) {
      // Error
    }
  }
}
