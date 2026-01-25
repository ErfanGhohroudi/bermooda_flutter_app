import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../hr_board_controller.dart';

mixin HRCreateUpdateSectionController {
  late final HRDepartmentReadDto department;
  late final HRBoardController controller;
  Section<HRSectionReadDto, BoardMemberReadDto>? section;
  final HrSectionDatasource _hrSectionDatasource = Get.find<HrSectionDatasource>();
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

  void setValue() {
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
    if (department.slug == null) return;
    _hrSectionDatasource.create(
      departmentSlug: department.slug!,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      onResponse: (final response) => UNavigator.back(),
      onError: (final errorResponse) {
        buttonState.loaded();
      },
    );
  }

  void update() {
    _hrSectionDatasource.update(
      slug: section?.data?.slug,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      onResponse: (final response) => UNavigator.back(),
      onError: (final errorResponse) {
        buttonState.loaded();
      },
    );
  }

  void getBoardIcons() {
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
    _hrSectionDatasource.delete(
      slug: section?.data?.slug,
      onResponse: () => UNavigator.back(),
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
