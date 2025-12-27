import 'package:u/utilities.dart';

import '../../../../data/data.dart';

mixin TransferMemberController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final HumanResourceDatasource _humanResourceDatasource = Get.find<HumanResourceDatasource>();
  final WorkShiftDatasource _workShiftsDatasource = Get.find<WorkShiftDatasource>();
  final MemberDatasource _memberDatasource = Get.find<MemberDatasource>();
  late DropdownItemReadDto selectedDepartment;
  DropdownItemReadDto? selectedWorkShift;
  final Rx<PageState> departmentsState = PageState.loading.obs;
  final Rx<PageState> workShiftsState = PageState.loading.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final RxList<DropdownItemReadDto> departments = <DropdownItemReadDto>[].obs;
  final RxList<DropdownItemReadDto> workShifts = <DropdownItemReadDto>[].obs;

  void disposeItems() {
    departmentsState.close();
    workShiftsState.close();
    buttonState.close();
    departments.close();
    workShifts.close();
  }

  void setValues({
    required final MemberReadDto member,
    required final HRDepartmentReadDto department,
  }) {
    selectedDepartment = DropdownItemReadDto(title: department.title, slug: department.slug);
    if (member.workShift != null) {
      selectedWorkShift = DropdownItemReadDto(
        slug: member.workShift?.slug,
        title: member.workShift?.title,
      );
    }
    _getDepartments();
    _getWorkShifts();
  }

  void onSubmit({
    required final MemberReadDto member,
    required final Function(MemberReadDto member) onResponse,
  }) {
    validateForm(
      key: formKey,
      action: () {
        _transferMember(member: member, onResponse: onResponse);
      },
    );
  }

  void setNewDepartment(final DropdownItemReadDto? newValue) {
    if (newValue != null && selectedDepartment.slug != newValue.slug) {
      selectedDepartment = newValue;
      selectedWorkShift = null;
      _getWorkShifts();
    }
  }

  void _getDepartments() {
    _humanResourceDatasource.getAllDepartmentsForDropdown(
      onResponse: (final response) {
        if (departments.subject.isClosed || departmentsState.subject.isClosed) return;
        departments(response.resultList);
        departmentsState.loaded();
      },
      onError: (final errorResponse) {
        if (departmentsState.subject.isClosed) return;
        departmentsState.loaded();
      },
      withRetry: true,
    );
  }

  void _getWorkShifts() {
    workShiftsState.loading();
    _workShiftsDatasource.getAllWorkShiftsForDropdown(
      slug: selectedDepartment.slug,
      onResponse: (final response) {
        if (workShifts.subject.isClosed || workShiftsState.subject.isClosed) return;
        workShifts(response.resultList);
        workShiftsState.loaded();
      },
      onError: (final errorResponse) {
        if (workShiftsState.subject.isClosed) return;
        workShiftsState.loaded();
      },
      withRetry: true,
    );
  }

  void _transferMember({
    required final MemberReadDto member,
    required final Function(MemberReadDto member) onResponse,
  }) {
    buttonState.loading();
    _memberDatasource.transferMember(
      memberId: member.id,
      departmentSlug: selectedDepartment.slug,
      workShiftSlug: selectedWorkShift?.slug,
      onResponse: (final response) {
        if (response.result == null) return;
        onResponse(response.result!);
        buttonState.loaded();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }
}
