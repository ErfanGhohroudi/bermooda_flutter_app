import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/kanban_board/kanban_board.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import 'support_board_controller.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../domain/entities/support_section.dart';
import '../../domain/usecases/create_board_section.dart';
import '../../domain/usecases/update_board_section.dart';
import '../../domain/usecases/delete_board_section.dart';

mixin SupportCreateUpdateSectionController {
  late final int departmentId;
  late final SupportBoardController controller;
  Section<SupportSection, dynamic>? section;

  final CreateBoardSectionUseCase _createUseCase = Get.find();
  final UpdateBoardSectionUseCase _updateUseCase = Get.find();
  final DeleteBoardSectionUseCase _deleteUseCase = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;

  final TextEditingController titleController = TextEditingController();
  LabelColors selectedColor = LabelColors.values.first;

  List<MainFileReadDto> iconsList = [];
  final int initialIconsListCount = 9;
  List<MainFileReadDto> initialIconsList = [];
  MainFileReadDto? selectedIcon;
  bool get showMoreIcon => iconsList.length > initialIconsListCount;

  void disposeItems() {
    titleController.dispose();
    buttonState.close();
  }

  void initialController({
    required final int departmentId,
    required final SupportBoardController controller,
    required final Section<SupportSection, dynamic>? section,
  }) {
    this.departmentId = departmentId;
    this.controller = controller;
    this.section = section;
    if (this.section != null) _setValue();
    // _getBoardIcons();
    pageState.loaded();
  }

  void _setValue() {
    titleController.text = section?.data?.title ?? '';
    selectedColor =
        LabelColors.values.firstWhereOrNull((final e) => e.color == section?.data?.colorCode?.toColor()) ??
        LabelColors.values.first;
    selectedIcon = section?.data?.icon;
  }

  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      buttonState.loading();
      if (section == null) {
        create();
      } else {
        update();
      }
    }
  }

  void create() {
    _createUseCase(
          departmentId: departmentId,
          title: titleController.text,
          color: selectedColor,
        )
        .then((final response) {
          // Assuming socket updates the board, just close the sheet
          AppNavigator.back();
        })
        .catchError((final error) {
          buttonState.loaded();
        });
  }

  void update() {
    _updateUseCase(
      id: section!.data!.id,
      title: titleController.text,
      color: selectedColor,
    ).then((final response) {
       AppNavigator.back();
    }).catchError((final error) {
       buttonState.loaded();
    });
  }

  void onDelete() {
    if (section?.data == null) return;
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem(s.section.toLowerCase()),
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () async {
        AppNavigator.back();
        try {
          await _deleteUseCase(section!.data!.id);
          AppNavigator.back();
        } catch(e) {
          // Error
        }
      },
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
}
