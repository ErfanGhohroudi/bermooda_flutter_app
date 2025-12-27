part of 'fields.dart';

class WAddressField extends StatefulWidget {
  const WAddressField({
    required this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.minLength = 3,
    this.maxLines = 5,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool? showRequired;
  final int minLength;
  final int maxLines;

  @override
  State<WAddressField> createState() => _WAddressFieldState();
}

class _WAddressFieldState extends State<WAddressField> {
  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      readOnly: widget.readOnly,
      labelText: s.address,
      required: widget.showRequired ?? widget.required,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.streetAddress,
      maxLines: widget.maxLines,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      helperStyle: context.textTheme.bodySmall!.copyWith(color: context.theme.primaryColor),
      textDirection: getDirection(widget.controller.text),
      formatters: [
        NoLeadingSpaceInputFormatter(),
        FilteringTextInputFormatter.deny(RegExp(r'[\n\t]')),
      ],
      validator: validateMinLength(
        widget.minLength,
        required: widget.required,
        requiredMessage: s.requiredField,
        minLengthMessage: s.isShort.replaceAll('#', widget.minLength.toString()),
      ),
    );
  }
}
