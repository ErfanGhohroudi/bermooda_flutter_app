import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../utils/extensions/color_extension.dart';
import '../../../utils/enums/enums.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'customer_status_reason_dropdown_multi_select_controller.dart';

class WStatusReasonMultiSelectFormField extends StatefulWidget {
  const WStatusReasonMultiSelectFormField({
    required this.crmCategoryId,
    required this.type,
    required this.onChanged,
    this.initialValues,
    this.required = false,
    this.showRequiredIcon,
    super.key,
  });

  final String crmCategoryId;
  final CustomerStatus type;
  final Function(List<StatusReasonReadDto> value) onChanged;
  final List<StatusReasonReadDto>? initialValues;
  final bool required;
  final bool? showRequiredIcon;

  @override
  State<WStatusReasonMultiSelectFormField> createState() => _WStatusReasonMultiSelectFormFieldState();
}

class _WStatusReasonMultiSelectFormFieldState extends State<WStatusReasonMultiSelectFormField> with StatusReasonMultiSelectController {
  @override
  void initState() {
    super.initState();
    type = widget.type;
    selectedItems.assignAll(widget.initialValues ?? []);

    getReasons(widget.crmCategoryId);
  }

  @override
  void didUpdateWidget(covariant final WStatusReasonMultiSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.crmCategoryId != widget.crmCategoryId || oldWidget.type != widget.type) {
      selectedItems.clear();
      widget.onChanged(selectedItems);
      getReasons(widget.crmCategoryId);
    }
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  void _openSelectionDialog(final FormFieldState<List<StatusReasonReadDto>> state) async {
    if (listState.isLoading()) return;

    final List<StatusReasonReadDto>? result = await showDialog<List<StatusReasonReadDto>>(
      context: context,
      builder: (final dialogContext) => _ReasonsMultiSelectDialog(
        projectId: widget.crmCategoryId,
        availableItems: items,
        initiallySelected: List.from(selectedItems),
        onDelete: (final label, final action) => deleteReason(
          label,
          action: () {
            selectedItems.removeWhere((final e) => e.slug == label.slug);
            widget.onChanged(selectedItems);
            action();
          },
        ),
        showCreateUpdateDialog: (final item) => showCreateUpdateLabelDialog(
          projectId: widget.crmCategoryId,
          item: item,
        ),
      ),
    );

    if (result != null) {
      state.didChange(result);
      selectedItems.assignAll(result);
      widget.onChanged(selectedItems);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return FormField<List<StatusReasonReadDto>>(
      initialValue: selectedItems,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: () => _openSelectionDialog(formFieldState),
        child: Obx(
          () => InputDecorator(
            decoration: InputDecoration(
              labelText: listState.isLoaded() ? (type == CustomerStatus.successful_sell ? s.wonReason : s.lossReason) : s.loading,
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
            isEmpty: selectedItems.isEmpty,
            child: selectedItems.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: selectedItems.map((final label) {
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

class _ReasonsMultiSelectDialog extends StatefulWidget {
  const _ReasonsMultiSelectDialog({
    required this.projectId,
    required this.availableItems,
    required this.initiallySelected,
    required this.onDelete,
    required this.showCreateUpdateDialog,
  });

  final String projectId;
  final List<StatusReasonReadDto> availableItems;
  final List<StatusReasonReadDto> initiallySelected;
  final Function(StatusReasonReadDto, VoidCallback) onDelete;
  final Function(StatusReasonReadDto?) showCreateUpdateDialog;

  @override
  State<_ReasonsMultiSelectDialog> createState() => _ReasonsMultiSelectDialogState();
}

class _ReasonsMultiSelectDialogState extends State<_ReasonsMultiSelectDialog> {
  late final List<StatusReasonReadDto> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.initiallySelected);
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
                // برای آپدیت شدن لیست در صورت ایجاد/حذف
                () => widget.availableItems.isNotEmpty
                    ? Scrollbar(
                        thumbVisibility: true,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...widget.availableItems.map((final label) {
                              final isSelected = _tempSelectedItems.any((final e) => e.slug == label.slug);
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
                                        _tempSelectedItems.add(label);
                                      } else {
                                        _tempSelectedItems.removeWhere((final e) => e.slug == label.slug);
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
                  onTap: () => Navigator.of(context).pop(_tempSelectedItems),
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

  Widget _buildManageMenu(final StatusReasonReadDto label) {
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
                      _tempSelectedItems.removeWhere((final e) => e.slug == label.slug);
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
