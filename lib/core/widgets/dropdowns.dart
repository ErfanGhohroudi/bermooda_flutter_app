part of 'widgets.dart';

class WDropDownFormField<T> extends StatefulWidget {
  const WDropDownFormField({
    required this.onChanged,
    required this.items,
    this.searchController,
    this.value,
    this.title,
    this.required = false,
    this.showRequiredIcon,
    this.deselectable = false,
    this.labelText,
    this.hintStyle,
    this.floatingLabelStyle,
    this.helperStyle,
    this.helperText,
    this.hintText,
    this.enable = true,
    this.showSearchField = false,
    this.onMenuStateChange,
    this.dropdownMenuWidth,
    this.maxDropDownHeight,
    this.hintSearchField,
    this.selectedItemBuilder,
    this.searchMatchFn,
    this.menuItemHeight = 42,
    super.key,
  });

  final TextEditingController? searchController;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final Function(T? value) onChanged;
  final Function(bool isOpen)? onMenuStateChange;
  final List<Widget> Function(BuildContext context)? selectedItemBuilder;
  final bool Function(DropdownMenuItem<T> item, String searchValue)? searchMatchFn;
  final String? title;
  final bool required;
  final bool? showRequiredIcon;
  final bool deselectable;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? helperStyle;
  final String? helperText;
  final String? hintText;
  final String? hintSearchField;
  final bool enable;
  final bool showSearchField;
  final double? dropdownMenuWidth;
  final double? maxDropDownHeight;
  final double menuItemHeight;

  @override
  State<WDropDownFormField> createState() => _WDropDownFormFieldState<T>();
}

class _WDropDownFormFieldState<T> extends State<WDropDownFormField<T>> {
  T? _currentItem;
  List<DropdownMenuItem<T>>? _items;
  late TextEditingController searchController;
  bool _isInternalController = false;

  @override
  void initState() {
    if (widget.searchController == null) {
      searchController = TextEditingController();
      _isInternalController = true;
    } else {
      searchController = widget.searchController!;
    }
    _currentItem = widget.value;
    _items = widget.items;
    super.initState();
  }

  @override
  void dispose() {
    if (_isInternalController) {
      searchController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WDropDownFormField<T> oldWidget) {
    if (oldWidget.value != widget.value ||
        oldWidget.items != widget.items ||
        oldWidget.selectedItemBuilder != widget.selectedItemBuilder) {
      setState(() {
        _currentItem = widget.value;
        _items = widget.items;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title != null) Text(widget.title ?? '', style: context.textTheme.bodyMedium).marginOnly(bottom: 8),
        DropdownButtonFormField2<T>(
          isExpanded: true,
          value: _currentItem,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.required
              ? (final dynamic value) {
                  if (value == null) return s.requiredField;
                  return null;
                }
              : null,
          items: _items,
          style: context.textTheme.bodyMedium!.copyWith(fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2),
          decoration: InputDecoration(
            enabled: widget.enable,
            fillColor: context.theme.dividerColor.withAlpha(50),
            filled: !widget.enable,
            labelText: widget.labelText != null
                ? "${widget.labelText}${(widget.showRequiredIcon ?? widget.required) ? '*' : ''}"
                : null,
            labelStyle:
                widget.hintStyle ??
                context.textTheme.bodyMedium!.copyWith(
                  fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
                  color: context.theme.hintColor,
                ),
            floatingLabelStyle: widget.floatingLabelStyle ?? context.textTheme.bodyLarge!,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            helperStyle: widget.helperStyle ?? context.textTheme.bodySmall,
            helperText: widget.helperText,
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ??
                context.textTheme.bodyMedium!.copyWith(
                  fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
                  color: context.theme.hintColor,
                ),
          ),
          onChanged: widget.enable
              ? (final T? newValue) {
                  if (newValue != null) {
                    setState(() {
                      if (_currentItem != newValue) {
                        _currentItem = newValue;
                      } else if (widget.deselectable) {
                        _currentItem = null;
                      }
                      searchController.clear();
                      _items = widget.items;
                    });
                    widget.onChanged(_currentItem);
                  }
                }
              : null,
          selectedItemBuilder: widget.selectedItemBuilder,
          buttonStyleData: ButtonStyleData(
            height: 35,
            padding: EdgeInsets.zero,
            width: context.width,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 30,
          ),
          dropdownStyleData: DropdownStyleData(
            width: widget.dropdownMenuWidth,
            maxHeight: widget.maxDropDownHeight ?? context.height / 2.5,
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            scrollbarTheme: context.theme.scrollbarTheme.copyWith(trackVisibility: const WidgetStatePropertyAll(false)),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: widget.menuItemHeight,
            selectedMenuItemBuilder: (final context, final child) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: context.theme.primaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: child,
            ),
          ),
          dropdownSearchData: widget.showSearchField
              ? DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: WSearchField(
                      controller: searchController,
                      hintText: widget.hintSearchField,
                      fillColor: context.theme.scaffoldBackgroundColor,
                    ),
                  ),
                  searchMatchFn:
                      widget.searchMatchFn ??
                      (final DropdownMenuItem<T> item, final String searchValue) {
                        if (item is DropdownMenuItem<DropdownItemReadDto>) {
                          final value = (item as DropdownMenuItem<DropdownItemReadDto>).value;
                          return value!.title.toString().toLowerCase().contains(searchValue.toLowerCase());
                        } else if (item is DropdownMenuItem<WorkspaceReadDto>) {
                          final value = (item as DropdownMenuItem<WorkspaceReadDto>).value;
                          return value!.title.toString().toLowerCase().contains(searchValue.toLowerCase());
                        } else {
                          return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                        }
                      },
                )
              : null,
          onMenuStateChange: (final isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
            if (widget.onMenuStateChange != null) {
              widget.onMenuStateChange!(isOpen);
            }
          },
        ),
      ],
    );
  }
}

List<DropdownMenuItem<DropdownItemReadDto>> getDropDownMenuItemsFromDropDownItemReadDto({
  required final List<DropdownItemReadDto> menuItems,
}) => List.generate(
  menuItems.length,
  (final index) => DropdownMenuItem<DropdownItemReadDto>(
    value: menuItems[index],
    child: WDropdownItemText(text: menuItems[index].title ?? ''),
  ),
);

List<DropdownMenuItem<String>> getDropDownMenuItemsFromString({
  required final List<String> menuItems,
}) => List.generate(
  menuItems.length,
  (final index) {
    final value = menuItems[index];
    return DropdownMenuItem<String>(
      value: value,
      child: WDropdownItemText(text: value),
    );
  },
);

List<DropdownMenuItem<WorkspaceReadDto>> getDropDownMenuItemsFromWorkspaceReadDto({
  required final BuildContext context,
  required final List<WorkspaceReadDto> menuItems,
}) => List.generate(
  menuItems.length,
  (final index) => DropdownMenuItem<WorkspaceReadDto>(
    value: menuItems[index],
    child: WDropdownItemText(
      text: menuItems[index].title ?? '',
    ),
  ),
);

class WDropdownItemText extends StatelessWidget {
  const WDropdownItemText({
    required this.text,
    this.maxLines = 2,
    super.key,
  });

  final String text;
  final int maxLines;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: context.textTheme.bodyMedium!.copyWith(
        overflow: TextOverflow.ellipsis,
        fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
        height: 1.2,
      ),
    );
  }
}
