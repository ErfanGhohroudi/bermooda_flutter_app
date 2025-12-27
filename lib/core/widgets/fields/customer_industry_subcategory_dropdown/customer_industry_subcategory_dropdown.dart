import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../widgets.dart';
import 'customer_industry_subcategory_dropdown_controller.dart';

class WCustomerCategoryDropdownFormField extends StatefulWidget {
  const WCustomerCategoryDropdownFormField({
    required this.crmCategoryId,
    required this.industry,
    required this.onChanged,
    this.value,
    this.required = false,
    this.showRequiredIcon,
    this.isManager = false,
    super.key,
  });

  final String crmCategoryId;
  final DropdownItemReadDto? industry;
  final Function(DropdownItemReadDto? value) onChanged;
  final DropdownItemReadDto? value;
  final bool required;
  final bool? showRequiredIcon;
  final bool isManager;

  @override
  State<WCustomerCategoryDropdownFormField> createState() => _WCustomerCategoryDropdownFormFieldState();
}

class _WCustomerCategoryDropdownFormFieldState extends State<WCustomerCategoryDropdownFormField> with CustomerCategoryDropdownController {
  @override
  void initState() {
    categoryId = widget.crmCategoryId;
    industry = widget.industry;
    selectedCategory = widget.value;
    if (!industryIsNotEmpty) {
      selectedCategory = null;
      widget.onChanged(selectedCategory);
    }
    if (industryIsNotEmpty) getCategories();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant final WCustomerCategoryDropdownFormField oldWidget) {
    if (oldWidget.industry != widget.industry) {
      industry = widget.industry;
      selectedCategory = null;
      widget.onChanged(selectedCategory);
      if (industryIsNotEmpty) {
        getCategories();
      } else {
        categories.clear();
      }
      return listState.refresh();
    }
    if (oldWidget.value != widget.value) {
      selectedCategory = widget.value;
      return listState.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    dropdownKey.close();
    listState.close();
    categories.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => WDropDownFormField<DropdownItemReadDto>(
        key: dropdownKey.value,
        enable: industryIsNotEmpty,
        labelText: listState.isLoaded() ? s.category : s.loading,
        value: selectedCategory,
        required: widget.required,
        showRequiredIcon: widget.showRequiredIcon,
        selectedItemBuilder: categories.isNotEmpty
            ? (final context) => List<DropdownMenuItem<DropdownItemReadDto>>.generate(
                  widget.isManager ? categories.length + 1 : categories.length,
                  (final index) {
                    final bool isOk = widget.isManager ? ((index - 1) >= 0) : true;
                    final DropdownItemReadDto category = widget.isManager && isOk ? categories[index - 1] : categories[index];

                    return DropdownMenuItem<DropdownItemReadDto>(
                      value: isOk ? category : null,
                      child: isOk ? _buildSelectedItemWidget() : const SizedBox(),
                    );
                  },
                )
            : null,
        items: listState.isLoaded()
            ? [
                if (widget.isManager) _buildCreateMenuItem(),
                ...List<DropdownMenuItem<DropdownItemReadDto>>.generate(
                  categories.length,
                  (final index) => _buildMenuItem(index),
                ),
              ]
            : [],
        onChanged: (final value) {
          selectedCategory = value;
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
  DropdownMenuItem<DropdownItemReadDto> _buildCreateMenuItem() {
    return DropdownMenuItem<DropdownItemReadDto>(
      value: DropdownItemReadDto(),
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
  DropdownMenuItem<DropdownItemReadDto> _buildMenuItem(final int index) {
    return DropdownMenuItem<DropdownItemReadDto>(
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
                        category: categories[index],
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
