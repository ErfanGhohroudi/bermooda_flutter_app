part of 'fields.dart';

class WPasswordField extends StatelessWidget {
  const WPasswordField({
    required this.controller,
    this.labelText,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.minLength = 8,
    this.autovalidateMode,
    this.confirmController,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool? showRequired;
  final int minLength;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? confirmController;

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: enabled,
      controller: controller,
      labelText: labelText ?? s.password,
      readOnly: readOnly,
      required: showRequired ?? required,
      autovalidateMode: autovalidateMode,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      onChanged: (final value) => controller.text = controller.text.englishNumber(),
      formatters: [
        // بلاک کردن حروف فارسی و عربی و فاصله و نیم فاصله
        FilteringTextInputFormatter.allow(RegExp(r'[!-~\u06F0-\u06F9]')),
      ],
      validator: confirmController == null
          ? validateMinLength(
              minLength,
              required: required,
              requiredMessage: s.requiredField,
              minLengthMessage: s.isShort.replaceAll('#', minLength.toString()),
            )
          : (final value) {
              if (value!.isEmpty && required) return s.requiredField;
              if (value != confirmController!.text) return s.passwordsNotSame;
              return null;
            },
    );
  }
}
