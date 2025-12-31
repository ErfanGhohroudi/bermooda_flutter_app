import 'package:u/utilities.dart';

import '../../../../../core/widgets/board_section_icons/icons_page.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/kanban_board/view_models/section_view_model.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../legal_board_controller.dart';
import 'legal_create_update_section_controller.dart';

class LegalCreateUpdateSectionPage extends StatefulWidget {
  const LegalCreateUpdateSectionPage({
    required this.department,
    required this.controller,
    this.section,
    super.key,
  });

  final LegalDepartmentReadDto department;
  final LegalBoardController controller;
  final Section<LegalSectionReadDto, LegalCaseReadDto>? section;

  @override
  State<LegalCreateUpdateSectionPage> createState() => _LegalCreateUpdateSectionPageState();
}

class _LegalCreateUpdateSectionPageState extends State<LegalCreateUpdateSectionPage> with LegalCreateUpdateSectionController {
  @override
  void initState() {
    initialController(
      department: widget.department,
      controller: widget.controller,
      section: widget.section,
    );
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (!pageState.isLoaded()) {
          return const SizedBox(
            width: double.maxFinite,
            height: 250,
            child: Center(child: WCircularLoading()),
          );
        }

        return Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 18,
                children: [
                  WTextField(
                    controller: titleController,
                    labelText: s.title,
                    required: true,
                    showRequired: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  GridView.builder(
                    itemCount: showMoreIcon ? (initialIconsList.length + 1) : initialIconsList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (final context, final index) {
                      if (showMoreIcon && index == initialIconsList.length) {
                        return Container(
                          color: Colors.transparent,
                          child: const Icon(Icons.arrow_forward_rounded, size: 30),
                        ).onTap(
                          () => UNavigator.push(
                            IconsPage(
                              icons: iconsList,
                              selectedIcon: selectedIcon,
                              selectedColor: selectedColor,
                              onSelected: (final icon) {
                                if (!initialIconsList.any((final e) => e.fileId == icon.fileId)) {
                                  initialIconsList.first = icon;
                                }
                                setState(() {
                                  selectedIcon = icon;
                                });
                              },
                            ),
                          ),
                        );
                      }
                      return _iconItem(initialIconsList[index], selectedColor);
                    },
                  ),
                  WColorPicker(
                    colors: LabelColors.values.map((final e) => e.color).toList(),
                    circleSize: 35,
                    initialColor: selectedColor.color,
                    onColorSelected: (final value) {
                      setState(() {
                        selectedColor = LabelColors.values.firstWhere((final e) => e.color == value);
                      });
                    },
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                if (section != null && controller.kanbanController.sections.first.slug != section?.slug)
                  WTextButton(
                    text: "${s.delete} ${s.section}",
                    textStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 14),
                    onPressed: onDelete,
                  ).marginOnly(bottom: 10),
                Obx(
                  () => UElevatedButton(
                    width: context.width,
                    title: section == null ? s.submit : s.save,
                    isLoading: buttonState.isLoading(),
                    onTap: onSubmit,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _iconItem(final MainFileReadDto icon, final LabelColors color) {
    final isSelected = selectedIcon?.fileId == icon.fileId;

    return WCard(
      color: isSelected ? color.color : (context.isDarkMode ? Colors.white30 : Colors.black12),
      child: UImage(icon.url ?? '', size: 30, color: isSelected ? Colors.white : context.theme.primaryColorDark),
      onTap: () => setState(() {
        selectedIcon = icon;
      }),
    );
  }
}
