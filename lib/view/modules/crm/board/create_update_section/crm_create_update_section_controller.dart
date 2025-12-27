import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../crm_board_controller.dart';

mixin CrmCreateUpdateSectionController {
  late final String categoryId;
  late final CrmBoardController controller;
  Section<CrmSectionReadDto, dynamic>? section;
  final CrmSectionDatasource _crmSectionDatasource = Get.find<CrmSectionDatasource>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<MainFileReadDto> iconsList = [];
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final int initialIconsListCount = 9;
  List<MainFileReadDto> initialIconsList = [];

  final TextEditingController titleController = TextEditingController();
  MainFileReadDto? selectedIcon;
  LabelColors selectedColor = LabelColors.values.first;

  final GlobalKey<FormState> stepFormKey = GlobalKey<FormState>();
  final TextEditingController stepTitleController = TextEditingController();
  final RxList<String> steps = <String>[].obs;

  bool get showMoreIcon => iconsList.length > initialIconsListCount;

  void disposeItems() {
    titleController.dispose();
    pageState.close();
    buttonState.close();
    stepTitleController.dispose();
    steps.close();
  }

  void initialController({
    required final String categoryId,
    required final CrmBoardController controller,
    required final Section<CrmSectionReadDto, CustomerReadDto>? section,
  }) {
    this.categoryId = categoryId;
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
    steps(section?.data?.steps?.map((final e) => e.title ?? '').toList());
    steps(steps.reversed.toList());
  }

  void addStep(final String value) {
    validateForm(
      key: stepFormKey,
      action: () {
        if (value.isNotEmpty) {
          steps.add(value);
          stepTitleController.clear();
        }
      },
    );
  }

  void onSubmit() {
    validateForm(
      key: formKey,
      action: () {
        if (steps.length < 2) {
          AppNavigator.snackbarRed(title: s.error, subtitle: s.stepLengthError);
          return;
        }

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
    _crmSectionDatasource.create(
      categoryId: categoryId,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      stepList: steps,
      onResponse: (final response) => UNavigator.back(),
      onError: (final errorResponse) => buttonState.loaded(),
    );
  }

  void update() {
    _crmSectionDatasource.update(
      id: section?.data?.id,
      categoryId: categoryId,
      title: titleController.text,
      colorCode: selectedColor.colorCode,
      iconId: selectedIcon?.fileId,
      stepList: steps,
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
    _crmSectionDatasource.delete(
      id: section?.data?.id,
      onResponse: () => UNavigator.back(),
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
