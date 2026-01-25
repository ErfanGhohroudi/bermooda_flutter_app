import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../legal_board_controller.dart';

mixin LegalCreateUpdateSectionController {
  late final LegalDepartmentReadDto department;
  late final LegalBoardController controller;
  Section<LegalSectionReadDto, LegalCaseReadDto>? section;
  final LegalSectionDatasource _legalSectionDatasource = Get.find<LegalSectionDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<MainFileReadDto> iconsList = [];
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final int initialIconsListCount = 9;
  List<MainFileReadDto> initialIconsList = [];

  final TextEditingController titleController = TextEditingController();
  MainFileReadDto? selectedIcon;
  LabelColors selectedColor = LabelColors.values.first;

  bool get showMoreIcon => iconsList.length > initialIconsListCount;

  void disposeItems() {
    titleController.dispose();
    pageState.close();
    buttonState.close();
  }

  void initialController({
    required final LegalDepartmentReadDto department,
    required final LegalBoardController controller,
    required final Section<LegalSectionReadDto, LegalCaseReadDto>? section,
  }) {
    this.department = department;
    this.controller = controller;
    this.section = section;
    if (this.section != null) _setValue();
    _getBoardIcons();
  }

  void _setValue() {
    titleController.text = section?.data?.title ?? '';
    selectedIcon = section?.data?.icon;
    selectedColor =
        LabelColors.values.firstWhereOrNull((final e) => e.color == section?.data?.colorCode?.toColor()) ??
        LabelColors.values.first;
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        if (section == null) {
          create();
        } else {
          update();
        }
      },
    );
  }

  void create() {
    if (department.id == null) return;
    _legalSectionDatasource.create(
      departmentId: department.id!,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      onResponse: (final response) => UNavigator.back(),
      onError: (final errorResponse) => buttonState.loaded(),
    );
  }

  void update() {
    _legalSectionDatasource.update(
      id: section?.data?.id,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      onResponse: (final response) => UNavigator.back(),
      onError: (final errorResponse) => buttonState.loaded(),
    );
  }

  void _getBoardIcons() {
    Get.find<ProjectDatasource>().getAllBoardIcons(
      onResponse: (final response) {
        iconsList = response.resultList ?? iconsList;
        selectedIcon ??= iconsList.firstOrNull;

        if (iconsList.length > initialIconsListCount) {
          initialIconsList = iconsList.take(initialIconsListCount).toList();
        } else {
          initialIconsList = response.resultList ?? initialIconsList;
        }

        if (selectedIcon != null && !initialIconsList.any((final e) => e.fileId == selectedIcon?.fileId)) {
          initialIconsList.first = selectedIcon!;
        }

        pageState.loaded();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void onDelete() {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete();
      },
    );
  }

  void _delete() {
    _legalSectionDatasource.delete(
      id: section?.data?.id,
      onResponse: () => UNavigator.back(),
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
