import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../utils/extensions/color_extension.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'crm_sections_dropdown_controller.dart';

class WCrmSectionsDropDownFormField extends StatefulWidget {
  const WCrmSectionsDropDownFormField({
    required this.crmCategoryId,
    required this.onChanged,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    super.key,
  });

  final String crmCategoryId;
  final Function(CrmSectionReadDto? value) onChanged;
  final CrmSectionReadDto? value;
  final bool required;
  final bool? showRequiredIcon;

  @override
  State<WCrmSectionsDropDownFormField> createState() => _WCrmSectionsDropDownFormFieldState();
}

class _WCrmSectionsDropDownFormFieldState extends State<WCrmSectionsDropDownFormField> with CrmSectionsDropdownController {
  @override
  void initState() {
    getSections(
      widget.crmCategoryId,
      action: (final list) {
        if (mounted) {
          selectedSection(list.firstWhereOrNull((final e) => e.id == widget.value?.id));
        }
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WCrmSectionsDropDownFormField oldWidget) {
    if (oldWidget.value != widget.value && mounted) {
      selectedSection(widget.value);
    }
    if (oldWidget.crmCategoryId != widget.crmCategoryId && mounted) {
      selectedSection(null);
      widget.onChanged(selectedSection.value);
      listState.loading();
      getSections(
        widget.crmCategoryId,
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
      () => WDropDownFormField<CrmSectionReadDto>(
        key: dropdownKey.value,
        labelText: listState.isLoaded() ? s.section : s.loading,
        value: selectedSection.value,
        required: widget.required,
        deselectable: !widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: sections.isNotEmpty
            ? (final context) => List<DropdownMenuItem<CrmSectionReadDto>>.generate(
                  canManage ? sections.length + 1 : sections.length,
                  (final index) {
                    final bool isOk = canManage ? ((index - 1) >= 0) : true;
                    final CrmSectionReadDto section = canManage && isOk ? sections[index - 1] : sections[index];

                    return DropdownMenuItem<CrmSectionReadDto>(
                      value: isOk ? section : null,
                      child: isOk ? _buildSelectedItemWidget() : const SizedBox(),
                    );
                  },
                )
            : null,
        menuItemHeight: 50,
        items: listState.isLoaded()
            ? [
                if (canManage) _buildCreateSectionMenuItem(),
                ...List<DropdownMenuItem<CrmSectionReadDto>>.generate(
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
  DropdownMenuItem<CrmSectionReadDto> _buildCreateSectionMenuItem() {
    return DropdownMenuItem<CrmSectionReadDto>(
      value: CrmSectionReadDto(),
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
                projectId: widget.crmCategoryId,
              );
            },
          );
        },
      ),
    );
  }

  /// متد کمکی برای ساخت هر آیتم بخش در لیست
  DropdownMenuItem<CrmSectionReadDto> _buildSectionMenuItem(final int index) {
    return DropdownMenuItem<CrmSectionReadDto>(
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
                        projectId: widget.crmCategoryId,
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
