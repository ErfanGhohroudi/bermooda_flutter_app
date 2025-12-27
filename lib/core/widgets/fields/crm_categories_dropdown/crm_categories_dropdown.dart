import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'crm_categories_dropdown_controller.dart';

class WCrmCategoriesDropdownFormField extends StatefulWidget {
  const WCrmCategoriesDropdownFormField({
    required this.onChanged,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    this.isManager = false,
    super.key,
  });

  final Function(CrmCategoryReadDto? value) onChanged;
  final CrmCategoryReadDto? value;
  final bool required;
  final bool? showRequiredIcon;
  final bool isManager;

  @override
  State<WCrmCategoriesDropdownFormField> createState() => _WCrmCategoriesDropdownFormFieldState();
}

class _WCrmCategoriesDropdownFormFieldState extends State<WCrmCategoriesDropdownFormField> with CrmCategoriesDropdownController {
  @override
  void initState() {
    selectedCategory = widget.value;
    getCategories();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WCrmCategoriesDropdownFormField oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        selectedCategory = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    listState.close();
    categories.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<CrmCategoryReadDto>(
        key: dropdownKey.value,
        labelText: listState.isLoaded() ? s.category : s.loading,
        value: selectedCategory,
        required: widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: categories.isNotEmpty
            ? (final context) => List<DropdownMenuItem<CrmCategoryReadDto>>.generate(
                  widget.isManager ? categories.length + 1 : categories.length,
                  (final index) {
                    final bool isOk = widget.isManager ? ((index - 1) >= 0) : true;
                    final CrmCategoryReadDto category = widget.isManager && isOk ? categories[index - 1] : categories[index];

                    return DropdownMenuItem<CrmCategoryReadDto>(
                      value: isOk ? category : null,
                      child: isOk ? _buildSelectedItemWidget() : const SizedBox(),
                    );
                  },
                )
            : null,
        items: listState.isLoaded()
            ? [
                if (widget.isManager) _buildCreateMenuItem(),
                ...List<DropdownMenuItem<CrmCategoryReadDto>>.generate(
                  categories.length,
                  (final index) => _buildMenuItem(index),
                ),
              ]
            : [],
        onChanged: (final value) {
          if (value == null) {
            selectedCategory = value;
          } else if (categories.contains(value)) {
            selectedCategory = value;
          }
          widget.onChanged(selectedCategory);
          listState.refresh();
        },
      ),
    );
  }

  /// متد کمکی برای ساخت ویجت آیتم انتخاب شده
  Widget _buildSelectedItemWidget() {
    return Text(
      selectedCategory?.title ?? '',
      maxLines: 2,
    ).bodyMedium(
      overflow: TextOverflow.ellipsis,
      fontSize: (navigatorKey.currentContext!.textTheme.bodyMedium!.fontSize ?? 12) + 2,
    );
  }

  /// متد کمکی برای ساخت آیتم
  DropdownMenuItem<CrmCategoryReadDto> _buildCreateMenuItem() {
    return DropdownMenuItem<CrmCategoryReadDto>(
      value: const CrmCategoryReadDto(),
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
                  Text(s.newCategory).titleMedium(color: context.theme.primaryColor),
                ],
              ),
              const Spacer(),
              if (categories.isNotEmpty) const Divider(),
            ],
          ),
        ),
      ).onTap(
        () {
          UNavigator.back();
          delay(50, () {
            showCreateUpdateDialog();
          });
        },
      ),
    );
  }

  /// متد کمکی برای ساخت هر آیتم در لیست
  DropdownMenuItem<CrmCategoryReadDto> _buildMenuItem(final int index) {
    return DropdownMenuItem<CrmCategoryReadDto>(
      value: categories[index],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categories[index].title ?? '',
            maxLines: 2,
          ).bodyMedium(
            overflow: TextOverflow.ellipsis,
            fontSize: (navigatorKey.currentContext!.textTheme.bodyMedium!.fontSize ?? 12) + 2,
          ),
          if (widget.isManager)
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
                      showCreateUpdateDialog(
                        project: categories[index],
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
                          deleteCategory(
                            categories[index],
                            action: () {
                              if (selectedCategory?.id == categories[index].id) {
                                setState(() {
                                  selectedCategory = null;
                                });
                                widget.onChanged(selectedCategory);
                              }
                              categories.removeAt(index);
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
