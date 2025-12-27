part of 'widgets.dart';

class WSearchField extends StatefulWidget {
  const WSearchField({
    required this.controller,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.hintText,
    this.suffix,
    this.onChanged,
    this.fillColor,
    this.textStyle,
    this.height,
    this.borderRadius,
    this.hintTextColor,
    this.contentPadding,
    this.textDirection,
    this.filterPageBuilder,
    this.haveActivatedFilter = false,
    this.withFilter = false,
    this.withClearIcon = true,
    this.searchIconSize = 20,
    this.searchIconColor,
    super.key,
  });

  final TextEditingController controller;
  final Duration debounceDuration;
  final String? hintText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final TextStyle? textStyle;
  final double? height;
  final double? borderRadius;
  final Color? hintTextColor;
  final EdgeInsets? contentPadding;
  final TextDirection? textDirection;
  final WidgetBuilder? filterPageBuilder;
  final bool haveActivatedFilter;
  final bool withFilter;
  final bool withClearIcon;
  final double searchIconSize;
  final Color? searchIconColor;

  @override
  State<WSearchField> createState() => _WSearchFieldState();
}

class _WSearchFieldState extends State<WSearchField> {
  Timer? _debounce;
  String _oldValue = '';

  @override
  void initState() {
    super.initState();
    _oldValue = widget.controller.text;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (widget.controller.text.trimRight() == _oldValue) return;
    _oldValue = widget.controller.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (widget.controller.text.startsWith(' ')) {
      widget.controller.text = widget.controller.text.substring(1);
    }

    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(widget.controller.text);
    });
  }

  void _openFilterSheet() async {
    if (widget.filterPageBuilder == null) return;

    await bottomSheet(
      title: s.filters,
      childBuilder: widget.filterPageBuilder!,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WSearchField oldWidget) {
    if (oldWidget.haveActivatedFilter != widget.haveActivatedFilter) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    final Widget clearIcon = SizedBox(
      width: 30,
      child: IconButton(
        onPressed: () {
          widget.controller.clear();
          _onTextChanged();
          setState(() {});
        },
        icon: Icon(
          Icons.clear,
          color: context.theme.hintColor,
        ),
      ),
    );

    final Widget filterIcon = IconButton(
      icon: UImage(
        AppIcons.filter,
        color: widget.haveActivatedFilter ? context.theme.primaryColor : context.theme.primaryColorDark,
        width: 24,
      ),
      onPressed: _openFilterSheet,
    );

    final Widget searchSuffix = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.withClearIcon && widget.controller.text.isNotEmpty) clearIcon,
        if (widget.withFilter)
          filterIcon
        else if (widget.suffix != null) ...[
          widget.suffix!,
          const SizedBox(width: 10),
        ],
      ],
    );

    final Widget searchPrefix = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: UImage(
        AppIcons.searchOutline,
        color: widget.searchIconColor ?? context.theme.primaryColorDark,
        width: widget.searchIconSize,
      ),
    );

    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: widget.fillColor ?? context.theme.cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          style: widget.textStyle ?? context.textTheme.titleMedium,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          maxLines: 1,
          textDirection: widget.textDirection ?? getDirection(widget.controller.text),
          inputFormatters: [NoLeadingSpaceInputFormatter()],
          onTapOutside: (final event) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            isDense: true,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: widget.hintText ?? s.search,
            hintStyle: context.textTheme.bodyMedium!.copyWith(color: widget.hintTextColor ?? context.theme.hintColor),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 40,
              maxWidth: 100,
            ),
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 40,
              maxWidth: 100,
            ),
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            suffixIcon: searchSuffix,
            prefixIcon: searchPrefix,
          ),
          onChanged: (final value) {
            setState(() {});
            _onTextChanged();
          },
        ),
      ),
    );
  }
}
