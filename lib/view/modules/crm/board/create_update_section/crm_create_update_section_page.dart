import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/board_section_icons/icons_page.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../core/widgets/kanban_board/view_models/section_view_model.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../crm_board_controller.dart';
import '../../../crm/board/create_update_section/crm_create_update_section_controller.dart';

class CrmCreateUpdateSectionPage extends StatefulWidget {
  const CrmCreateUpdateSectionPage({
    required this.categoryId,
    required this.controller,
    this.section,
    super.key,
  });

  final String categoryId;
  final CrmBoardController controller;
  final Section<CrmSectionReadDto, CustomerReadDto>? section;

  @override
  State<CrmCreateUpdateSectionPage> createState() => _CrmCreateUpdateSectionPageState();
}

class _CrmCreateUpdateSectionPageState extends State<CrmCreateUpdateSectionPage> with CrmCreateUpdateSectionController {
  @override
  void initState() {
    initialController(
      categoryId: widget.categoryId,
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
            _steps().marginOnly(top: 24),
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

  Widget _steps() => WCard(
        showBorder: true,
        child: WExpansionTile(
          value: section == null,
          title: s.steps,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Form(
                  key: stepFormKey,
                  child: WTextField(
                    controller: stepTitleController,
                    hintText: s.enterStepTitle,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    suffixIcon: Icon(CupertinoIcons.add_circled, size: 30, color: context.theme.primaryColor).onTap(
                      () => addStep(stepTitleController.text),
                    ),
                    onEditingComplete: () => addStep(stepTitleController.text),
                  ),
                ).marginOnly(bottom: steps.isNotEmpty? 10 : 0),
                ...steps.map((final step) => _stepItem(step)),
                const SizedBox(height: 10),
              ],
            ),
          ),
          onChanged: (final value) {},
        ),
      );

  Widget _stepItem(final String step) => Container(
        width: context.width,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 6, 8),
        decoration: BoxDecoration(
          border: Border.all(color: context.theme.hintColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(step).bodyMedium(color: context.theme.hintColor)),
            const UImage(AppIcons.delete, size: 30, color: AppColors.red).onTap(() {
              final i = steps.indexOf(step);
              if (i != -1) {
                steps.removeAt(i);
              }
            }),
          ],
        ),
      );
}
