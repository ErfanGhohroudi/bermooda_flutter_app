import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../utils/extensions/color_extension.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'customer_labels_dropdown_multi_select_controller.dart';

class WCustomerLabelsMultiSelectFormField extends StatefulWidget {
  const WCustomerLabelsMultiSelectFormField({
    required this.crmCategoryId,
    required this.onChanged,
    this.labelText,
    this.initialValues,
    this.required = false,
    this.showRequiredIcon,
    super.key,
  });

  final String crmCategoryId;
  final String? labelText;
  final Function(List<LabelReadDto> value) onChanged;
  final List<LabelReadDto>? initialValues;
  final bool required;
  final bool? showRequiredIcon;

  @override
  State<WCustomerLabelsMultiSelectFormField> createState() => _WCustomerLabelsMultiSelectFormFieldState();
}

class _WCustomerLabelsMultiSelectFormFieldState extends State<WCustomerLabelsMultiSelectFormField> with CustomerLabelsMultiSelectController {
  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه با لیست ورودی
    selectedLabels.assignAll(widget.initialValues ?? []);

    // دریافت لیست کامل لیبل‌ها از سرور
    getLabels(widget.crmCategoryId);
  }

  @override
  void didUpdateWidget(covariant final WCustomerLabelsMultiSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.crmCategoryId != widget.crmCategoryId) {
      selectedLabels.clear();
      widget.onChanged(selectedLabels);
      listState.loading();
      getLabels(widget.crmCategoryId);
    }
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  // متدی برای باز کردن دیالوگ انتخاب
  void _openSelectionDialog(final FormFieldState<List<LabelReadDto>> state) async {
    // اگر لیبل‌ها هنوز لود نشده‌اند، کاری نکن
    if (listState.isLoading()) return;

    final List<LabelReadDto>? result = await showDialog<List<LabelReadDto>>(
      context: context,
      builder: (final dialogContext) => _LabelsMultiSelectDialog(
        projectId: widget.crmCategoryId,
        availableLabels: labels,
        initiallySelected: List.from(selectedLabels),
        onDelete: (final label, final action) => deleteLabel(
          label,
          action: () {
            selectedLabels.removeWhere((final e) => e.id == label.id);
            widget.onChanged(selectedLabels);
            action();
          },
        ),
        showCreateUpdateDialog: (final label) => showCreateUpdateLabelDialog(
          crmCategoryId: widget.crmCategoryId,
          label: label,
        ),
      ),
    );

    if (result != null) {
      state.didChange(result);
      selectedLabels.assignAll(result);
      widget.onChanged(selectedLabels);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return FormField<List<LabelReadDto>>(
      initialValue: selectedLabels,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: () => _openSelectionDialog(formFieldState),
        child: Obx(
          () => InputDecorator(
            decoration: InputDecoration(
              labelText: listState.isLoading() ? s.loading : (widget.labelText ?? s.label),
              labelStyle: context.textTheme.bodyMedium!.copyWith(
                fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
                color: context.theme.hintColor,
              ),
              floatingLabelStyle: context.textTheme.bodyLarge!,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              errorText: formFieldState.errorText,
              suffixIcon: Container(margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0), child: const Icon(Icons.arrow_drop_down_rounded, size: 30)),
            ),
            isEmpty: selectedLabels.isEmpty,
            child: selectedLabels.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: selectedLabels.map((final label) {
                      return WLabel(
                        text: label.title ?? '',
                        color: label.colorCode.toColor(),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ),
    );
  }
}

class _LabelsMultiSelectDialog extends StatefulWidget {
  const _LabelsMultiSelectDialog({
    required this.projectId,
    required this.availableLabels,
    required this.initiallySelected,
    required this.onDelete,
    required this.showCreateUpdateDialog,
  });

  final String projectId;
  final List<LabelReadDto> availableLabels;
  final List<LabelReadDto> initiallySelected;
  final Function(LabelReadDto, VoidCallback) onDelete;
  final Function(LabelReadDto?) showCreateUpdateDialog;

  @override
  State<_LabelsMultiSelectDialog> createState() => _LabelsMultiSelectDialogState();
}

class _LabelsMultiSelectDialogState extends State<_LabelsMultiSelectDialog> {
  late final List<LabelReadDto> _tempSelectedLabels;

  @override
  void initState() {
    super.initState();
    _tempSelectedLabels = List.from(widget.initiallySelected);
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.selectLabels).titleMedium(color: context.theme.hintColor),
          const Divider(),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            _buildCreateLabelTile().paddingSymmetric(horizontal: 16),
            SizedBox(
              width: double.maxFinite,
              height: context.height / 2.5,
              child: Obx(
                // برای آپدیت شدن لیست در صورت ایجاد/حذف لیبل
                () => widget.availableLabels.isNotEmpty
                    ? Scrollbar(
                        thumbVisibility: true,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...widget.availableLabels.map((final label) {
                              final isSelected = _tempSelectedLabels.any((final e) => e.id == label.id);
                              return Theme(
                                data: ThemeData(
                                  listTileTheme: const ListTileThemeData(horizontalTitleGap: 0, contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                                ),
                                child: CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  side: WidgetStateBorderSide.resolveWith(
                                    (final states) {
                                      if (states.contains(WidgetState.selected)) {
                                        return const BorderSide(color: AppColors.green, width: 2);
                                      }
                                      return const BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      );
                                    },
                                  ),
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  checkColor: Colors.white,
                                  activeColor: AppColors.green,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    spacing: 10,
                                    children: [
                                      Flexible(child: WLabel(text: label.title ?? '', color: label.colorCode.toColor())),
                                      _buildManageMenu(label),
                                    ],
                                  ),
                                  value: isSelected,
                                  onChanged: (final value) {
                                    setState(() {
                                      if (value == true) {
                                        _tempSelectedLabels.add(label);
                                      } else {
                                        _tempSelectedLabels.removeWhere((final e) => e.id == label.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      )
                    : const Center(child: WEmptyWidget()),
              ),
            ),
            Row(
              spacing: 10,
              children: [
                UElevatedButton(
                  title: s.cancel,
                  backgroundColor: context.theme.hintColor,
                  onTap: UNavigator.back,
                ).expanded(),
                UElevatedButton(
                  title: s.confirm,
                  onTap: () => Navigator.of(context).pop(_tempSelectedLabels),
                ).expanded(),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildCreateLabelTile() {
    return UElevatedButton(
      width: context.width,
      icon: Icon(Icons.add_rounded, color: context.theme.primaryColor),
      title: s.newLabel,
      titleColor: context.theme.primaryColor,
      borderColor: context.theme.primaryColor,
      borderWidth: 2,
      backgroundColor: context.theme.cardColor,
      onTap: () {
        widget.showCreateUpdateDialog(null);
      },
    );
  }

  Widget _buildManageMenu(final LabelReadDto label) {
    return Row(
      children: [
        Icon(Icons.more_vert_rounded, color: context.theme.hintColor).showMenus([
          WPopupMenuItem(
            title: s.edit,
            titleColor: AppColors.green,
            icon: AppIcons.editOutline,
            iconColor: AppColors.green,
            onTap: () => widget.showCreateUpdateDialog(label),
          ),
          WPopupMenuItem(
            title: s.delete,
            titleColor: AppColors.red,
            icon: AppIcons.delete,
            iconColor: AppColors.red,
            onTap: () {
              appShowYesCancelDialog(
                title: s.delete,
                description: s.areYouSureYouWantToDeleteItem,
                yesButtonTitle: s.delete,
                yesBackgroundColor: AppColors.red,
                onYesButtonTap: () {
                  UNavigator.back(); // بستن دیالوگ تایید
                  widget.onDelete(label, () {
                    // حذف از لیست‌های موقت و اصلی
                    setState(() {
                      _tempSelectedLabels.removeWhere((final e) => e.id == label.id);
                    });
                  });
                },
              );
            },
          ),
        ]),
        const SizedBox(width: 10),
      ],
    );
  }
}
