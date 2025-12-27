import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../../data/remote_datasource/label/interfaces/label_interface.dart';
import '../../../utils/extensions/color_extension.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'labels_dropdown_controller_new.dart';

/// Just for labels that have slug
class WLabelsDropDownFormFieldNew extends StatefulWidget {
  const WLabelsDropDownFormFieldNew({
    required this.sourceId,
    required this.onChanged,
    required this.datasource,
    this.labelText,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    super.key,
  });

  final String sourceId;
  final String? labelText;
  final Function(LabelReadDto? value) onChanged;
  final ILabelDatasource datasource;
  final LabelReadDto? value;
  final bool required;
  final bool? showRequiredIcon;

  @override
  State<WLabelsDropDownFormFieldNew> createState() => _WLabelsDropDownFormFieldNewState();
}

class _WLabelsDropDownFormFieldNewState extends State<WLabelsDropDownFormFieldNew> with LabelsDropdownController {
  @override
  void initState() {
    datasource = widget.datasource;
    getLabels(
      widget.sourceId,
      action: (final list) {
        if (mounted) {
          selectedLabel.value = list.firstWhereOrNull((final e) {
            if (e.slug != null) {
              return e.slug == widget.value?.slug;
            } else if (e.id != null) {
              return e.id == widget.value?.id;
            }
            return false;
          });
          selectedLabel.refresh();
        }
        if (widget.value != null && selectedLabel.value == null) {
          widget.onChanged(null);
        }
      },
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WLabelsDropDownFormFieldNew oldWidget) {
    if (oldWidget.value != widget.value && mounted) {
      selectedLabel.value = widget.value;
      selectedLabel.refresh();
    }
    if (oldWidget.sourceId != widget.sourceId && mounted) {
      selectedLabel.value = null;
      selectedLabel.refresh();
      widget.onChanged(selectedLabel.value);
      listState.loading();
      getLabels(
        widget.sourceId,
        action: (final list) {
          if (mounted) {
            selectedLabel.value = list.firstWhereOrNull((final e) => e.slug == widget.value?.slug);
            selectedLabel.refresh();
          }
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    listState.close();
    labels.close();
    dropdownKey.close();
    selectedLabel.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<LabelReadDto>(
        key: dropdownKey.value,
        labelText: listState.isLoaded() ? (widget.labelText ?? s.label) : s.loading,
        value: selectedLabel.value,
        required: widget.required,
        deselectable: !widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: labels.isNotEmpty
            ? (final context) => List<DropdownMenuItem<LabelReadDto>>.generate(
                canManage ? labels.length + 1 : labels.length,
                (final index) {
                  final bool isOk = canManage ? ((index - 1) >= 0) : true;
                  final LabelReadDto label = canManage && isOk ? labels[index - 1] : labels[index];

                  return DropdownMenuItem<LabelReadDto>(
                    value: isOk ? label : null,
                    child: isOk ? _buildSelectedItemWidget() : const SizedBox(),
                  );
                },
              )
            : null,
        menuItemHeight: 50,
        items: listState.isLoaded()
            ? [
                if (canManage) _buildCreateLabelMenuItem(),
                ...List<DropdownMenuItem<LabelReadDto>>.generate(
                  labels.length,
                  (final index) => _buildLabelMenuItem(index),
                ),
              ]
            : [],
        onChanged: (final value) {
          if (value == null) {
            selectedLabel.value = value;
            selectedLabel.refresh();
          } else if (labels.contains(value)) {
            selectedLabel(value);
          }
          widget.onChanged(selectedLabel.value);
          listState.refresh();
        },
      ),
    );
  }

  // متد کمکی برای ساخت ویجت آیتم انتخاب شده
  Widget _buildSelectedItemWidget() {
    return WLabel(
      text: selectedLabel.value?.title ?? '',
      color: selectedLabel.value?.colorCode.toColor(),
    );
  }

  // متد کمکی برای ساخت آیتم "ایجاد لیبل جدید"
  DropdownMenuItem<LabelReadDto> _buildCreateLabelMenuItem() {
    return DropdownMenuItem<LabelReadDto>(
      value: LabelReadDto(),
      child:
          Container(
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
                      Text(s.newLabel).titleMedium(color: context.theme.primaryColor),
                    ],
                  ),
                  const Spacer(),
                  if (labels.isNotEmpty) const Divider(),
                ],
              ),
            ),
          ).onTap(
            () {
              UNavigator.back();
              delay(
                50,
                () {
                  showCreateUpdateLabelDialog(
                    sourceId: widget.sourceId,
                  );
                },
              );
            },
          ),
    );
  }

  /// متد کمکی برای ساخت هر آیتم لیبل در لیست
  DropdownMenuItem<LabelReadDto> _buildLabelMenuItem(final int index) {
    return DropdownMenuItem<LabelReadDto>(
      value: labels[index],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WLabel(
            text: labels[index].title ?? '',
            color: labels[index].colorCode.toColor(),
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
                      showCreateUpdateLabelDialog(
                        sourceId: widget.sourceId,
                        label: labels[index],
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
                          deleteLabel(
                            labels[index],
                            action: () {
                              if (selectedLabel.value?.slug == labels[index].slug) {
                                selectedLabel.value = null;
                                selectedLabel.refresh();
                                widget.onChanged(selectedLabel.value);
                              }
                              labels.removeAt(index);
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
