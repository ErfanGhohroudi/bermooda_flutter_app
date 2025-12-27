part of 'fields.dart';

class WTextField extends StatefulWidget {
  const WTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.minLength = 1,
    this.maxLength = 200,
    this.autovalidateMode,
    this.helperText,
    this.onEditingComplete,
    this.multiLine = false,
    this.showCounter = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.onTapOutside,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool? showRequired;
  final int minLength;
  final int maxLength;
  final AutovalidateMode? autovalidateMode;
  final String? helperText;
  final Function()? onEditingComplete;
  final bool multiLine;
  final bool showCounter;
  final int minLines;
  final int maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(PointerDownEvent event)? onTapOutside;

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      readOnly: widget.readOnly,
      labelText: widget.labelText,
      hintText: widget.hintText,
      required: widget.showRequired ?? widget.required,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.multiLine ? TextInputType.multiline : TextInputType.text,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      maxLength: widget.maxLength,
      helperText: widget.helperText,
      helperStyle: context.textTheme.bodySmall!.copyWith(color: context.theme.primaryColor),
      onEditingComplete: widget.onEditingComplete,
      textDirection: getDirection(widget.controller.text),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
      onTapOutside: widget.onTapOutside,
      showCounter: widget.showCounter,
      validator: validateMinLength(
        widget.minLength,
        required: widget.required,
        requiredMessage: s.requiredField,
        minLengthMessage: s.isShort.replaceAll('#', widget.minLength.toString()),
      ),
      formatters: [NoLeadingSpaceInputFormatter()],
      onChanged: (final value) {
        setState(() {});
      },
    );
  }
}
