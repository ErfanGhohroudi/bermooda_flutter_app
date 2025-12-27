part of 'fields.dart';

class WEmailField extends StatelessWidget {
  const WEmailField({
    required this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.showRequired,
    this.hintText = "example@gmail.com",
    this.onEditingComplete,
    this.helperText,
    this.helperStyle,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool? showRequired;
  final String hintText;
  final Function()? onEditingComplete;
  final String? helperText;
  final TextStyle? helperStyle;

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: enabled,
      controller: controller,
      readOnly: readOnly,
      labelText: s.email,
      hintText: hintText,
      required: showRequired ?? required,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: onEditingComplete,
      helperText: helperText,
      helperStyle: helperStyle,
      formatters: [FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF\s\t\n\u200C]'))],
      validator: validateEmail(
        required: required,
        requiredMessage: s.requiredField,
        notEmailMessage: s.invalidEmailAddress,
      ),
    );
  }
}
