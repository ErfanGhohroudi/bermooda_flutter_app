part of 'widgets.dart';

class WSwitch extends StatelessWidget {
  const WSwitch({
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.thumbColor,
    this.inactiveThumbColor,
    this.thumbIcon,
    super.key,
  });

  final bool value;
  final Function(bool value) onChanged;
  final Color? activeTrackColor;
  final Color? thumbColor;
  final Color? inactiveThumbColor;
  final WidgetStateProperty<Icon?>? thumbIcon;

  @override
  Widget build(final BuildContext context) {
    return CupertinoSwitch(
      value: value,
      activeTrackColor: activeTrackColor ?? context.theme.primaryColor,
      thumbColor: thumbColor ?? Colors.white,
      inactiveThumbColor: inactiveThumbColor ?? Colors.white,
      thumbIcon: thumbIcon,
      onChanged: onChanged,
    );
  }
}

class WSwitchForm extends StatelessWidget {
  const WSwitchForm({
    required this.value,
    required this.title,
    required this.onChanged,
    this.icon,
    super.key,
  });

  final bool value;
  final String title;
  final String? icon;
  final Function() onChanged;

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          if (icon != null) UImage(icon!, color: context.theme.primaryColorDark, size: 25),
          if (icon != null) const SizedBox(width: 10),
          Text(title).bodyMedium().expanded(),
          WSwitch(
            value: value,
            onChanged: (final value) => onChanged(),
          ),
        ],
      ),
    ).onTap(() => onChanged());
  }
}

