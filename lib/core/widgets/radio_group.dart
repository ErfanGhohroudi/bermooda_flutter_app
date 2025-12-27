part of 'widgets.dart';

class WRadioGroup<T> extends StatefulWidget {
  const WRadioGroup({
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
    this.initialValue,
    this.enable = true,
    this.direction = Axis.horizontal,
    super.key,
  });

  final List<T> items;
  final T? initialValue;
  final void Function(T value) onChanged;
  final String Function(T item) labelBuilder;
  final bool enable;
  final Axis direction;

  @override
  State<WRadioGroup<T>> createState() => _WRadioGroupState<T>();
}

class _WRadioGroupState<T> extends State<WRadioGroup<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: widget.direction,
      alignment: WrapAlignment.start,
      children: widget.items.map((final item) {
        final isSelected = selectedValue == item;

        return Container(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: item,
                groupValue: selectedValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: WidgetStatePropertyAll(widget.enable ? (isSelected ? context.theme.primaryColor : context.theme.hintColor) : context.theme.dividerColor),
                onChanged: (final value) {
                  if (value != null && widget.enable) {
                    setState(() => selectedValue = value);
                    widget.onChanged(value);
                  }
                },
              ),
              Text(widget.labelBuilder(item)).bodyMedium(),
            ],
          ),
        ).onTap(() {
          if (widget.enable) {
            setState(() => selectedValue = item);
            widget.onChanged(item);
          }
        });
      }).toList(),
    );
  }
}
