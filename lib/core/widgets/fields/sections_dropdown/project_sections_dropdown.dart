import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../utils/extensions/color_extension.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'project_sections_dropdown_controller.dart';

class WProjectSectionsDropDownFormField extends StatefulWidget {
  const WProjectSectionsDropDownFormField({
    required this.projectId,
    required this.onChanged,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    super.key,
  });

  final String projectId;
  final Function(ProjectSectionReadDto? value) onChanged;
  final ProjectSectionReadDto? value;
  final bool required;
  final bool? showRequiredIcon;

  @override
  State<WProjectSectionsDropDownFormField> createState() => _WProjectSectionsDropDownFormFieldState();
}

class _WProjectSectionsDropDownFormFieldState extends State<WProjectSectionsDropDownFormField> with ProjectSectionsDropdownController {
  @override
  void initState() {
    getSections(
      widget.projectId,
      action: (final list) {
        if (mounted) {
          selectedSection(list.firstWhereOrNull((final e) => e.id == widget.value?.id));
        }
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WProjectSectionsDropDownFormField oldWidget) {
    if (oldWidget.value != widget.value && mounted) {
      selectedSection(widget.value);
    }
    if (oldWidget.projectId != widget.projectId && mounted) {
      selectedSection(null);
      widget.onChanged(selectedSection.value);
      listState.loading();
      getSections(
        widget.projectId,
        action: (final list) {
          if (mounted) {
            selectedSection(list.firstWhereOrNull((final e) => e.id == widget.value?.id));
          }
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    listState.close();
    sections.close();
    dropdownKey.close();
    selectedSection.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<ProjectSectionReadDto>(
        key: dropdownKey.value,
        labelText: listState.isLoaded() ? s.section : s.loading,
        value: selectedSection.value,
        required: widget.required,
        deselectable: !widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: sections.isNotEmpty
            ? (final context) => List<DropdownMenuItem<ProjectSectionReadDto>>.generate(
                  canManage ? sections.length + 1 : sections.length,
                  (final index) {
                    final bool isOk = canManage ? ((index - 1) >= 0) : true;
                    final ProjectSectionReadDto section = canManage && isOk ? sections[index - 1] : sections[index];

                    return DropdownMenuItem<ProjectSectionReadDto>(
                      value: isOk ? section : null,
                      child: isOk
                          ? _buildSelectedItemWidget()
                          : const SizedBox(),
                    );
                  },
                )
            : null,
        menuItemHeight: 50,
        items: listState.isLoaded()
            ? [
                if (canManage)
                  _buildCreateSectionMenuItem(),
                ...List<DropdownMenuItem<ProjectSectionReadDto>>.generate(
                  sections.length,
                  (final index) => _buildSectionMenuItem(index),
                ),
              ]
            : [],
        onChanged: (final value) {
          if (value == null) {
            selectedSection(value);
          } else if (sections.contains(value)) {
            selectedSection(value);
          }
          widget.onChanged(selectedSection.value);
          listState.refresh();
        },
      ),
    );
  }

  // متد کمکی برای ساخت ویجت آیتم انتخاب شده
  Widget _buildSelectedItemWidget() {
    return WLabel(
      text: selectedSection.value?.title ?? '',
      color: selectedSection.value?.colorCode.toColor(),
    );
  }

  // متد کمکی برای ساخت آیتم "ایجاد بخش جدید"
  DropdownMenuItem<ProjectSectionReadDto> _buildCreateSectionMenuItem() {
    return DropdownMenuItem<ProjectSectionReadDto>(
      value: ProjectSectionReadDto(),
      child: Container(
        width: context.width,
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.add_rounded, size: 20, color: context.theme.primaryColor),
                  Text(s.newSection).titleMedium(color: context.theme.primaryColor),
                ],
              ),
              const Spacer(),
              if (sections.isNotEmpty) const Divider(),
            ],
          ),
        ),
      ).onTap(
        () {
          UNavigator.back();
          delay(
            50,
            () {
              showCreateUpdateSectionDialog(
                projectId: widget.projectId,
              );
            },
          );
        },
      ),
    );
  }

  /// متد کمکی برای ساخت هر آیتم بخش در لیست
  DropdownMenuItem<ProjectSectionReadDto> _buildSectionMenuItem(final int index) {
    return DropdownMenuItem<ProjectSectionReadDto>(
      value: sections[index],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WLabel(
            text: sections[index].title ?? '',
            color: sections[index].colorCode.toColor(),
          ),
          if (canManage)
            Icon(
              Icons.more_vert_rounded,
              color: context.theme.hintColor,
            ).showMenus([
              WPopupMenuItem(
                title: s.edit,
                titleColor: AppColors.green,
                icon: AppIcons.editOutline,
                iconColor: AppColors.green,
                onTap: () {
                  UNavigator.back();
                  delay(
                    50,
                    () {
                      showCreateUpdateSectionDialog(
                        projectId: widget.projectId,
                        section: sections[index],
                      );
                    },
                  );
                },
              ),
              WPopupMenuItem(
                title: s.delete,
                titleColor: AppColors.red,
                icon: AppIcons.delete,
                iconColor: AppColors.red,
                onTap: () {
                  UNavigator.back();
                  delay(
                    50,
                    () {
                      appShowYesCancelDialog(
                        title: s.delete,
                        description: s.areYouSureToDeleteMessage,
                        yesButtonTitle: s.delete,
                        yesBackgroundColor: AppColors.red,
                        onYesButtonTap: () {
                          UNavigator.back();
                          deleteSection(
                            sections[index],
                            action: () {
                              if (selectedSection.value?.id == sections[index].id) {
                                  selectedSection(null);
                                widget.onChanged(selectedSection.value);
                              }
                              sections.removeAt(index);
                              listState.refresh();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ]),
        ],
      ),
    );
  }
}
