part of 'fields.dart';

class WPhoneNumberField extends StatelessWidget {
  const WPhoneNumberField({
    required this.controller,
    this.enabled = true,
    this.labelText,
    this.autofocus = false,
    this.readOnly = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.required = false,
    this.showRequired,
    this.hintText, // = '0912xxxxxxx',
    this.startWith, // = '09',
    this.minLength = 1,
    this.maxLength = 20,
    this.onEditingComplete,
    this.helperText,
    this.helperStyle,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final bool required;
  final bool? showRequired;

  final String? hintText;
  final String? startWith;
  final int minLength;
  final int maxLength;
  final Function()? onEditingComplete;
  final String? helperText;
  final TextStyle? helperStyle;

  @override
  Widget build(final BuildContext context) {
    // return PhoneFormField(
    //   enabled: enabled,
    //   // initialValue: PhoneNumber.parse(controller.text),
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   // defaultCountry: IsoCode.DE,
    //   onTapOutside: (final event) => FocusManager.instance.primaryFocus?.unfocus(),
    //   keyboardType: TextInputType.phone,
    //   isCountrySelectionEnabled: true,
    //   isCountryButtonPersistent: true,
    //   countryButtonStyle: const CountryButtonStyle(
    //     showDialCode: true,
    //     showIsoCode: false,
    //     showFlag: true,
    //     flagSize: 16,
    //   ),
    //   countrySelectorNavigator: CountrySelectorNavigator.modalBottomSheet(
    //       backgroundColor: context.theme.scaffoldBackgroundColor,
    //       height: context.height / 1.5,
    //       titleStyle: context.textTheme.bodyMedium,
    //       subtitleStyle: context.textTheme.bodyMedium!.copyWith(color: context.theme.hintColor),
    //       noResultMessage: s.listIsEmpty,
    //       searchBoxDecoration: InputDecoration(
    //         prefixIcon: Padding(
    //           padding: const EdgeInsets.all(10),
    //           child: UImage(AppIcons.searchOutline, size: 20, color: context.theme.hintColor),
    //         ),
    //         hintText: s.search,
    //         hintStyle: context.textTheme.bodyMedium!.copyWith(
    //           fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
    //           color: context.theme.hintColor,
    //         ),
    //       )),
    //   decoration: InputDecoration(
    //     fillColor: context.theme.dividerColor.withAlpha(50),
    //     filled: !enabled,
    //     isDense: false,
    //     labelText: "${labelText ?? s.phoneNumber}${required ? '*' : ''}",
    //     helperText: helperText,
    //     helperStyle: helperStyle ?? context.textTheme.bodySmall,
    //     labelStyle: context.textTheme.bodyMedium!.copyWith(
    //       fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
    //       color: context.theme.hintColor,
    //     ),
    //     floatingLabelStyle: context.textTheme.bodyLarge!,
    //     floatingLabelBehavior: FloatingLabelBehavior.auto,
    //   ),
    //   validator: PhoneValidator.compose([
    //     if (required) PhoneValidator.required(context, errorText: s.requiredField),
    //     PhoneValidator.valid(context, errorText: s.invalidPhoneNumber),
    //     PhoneValidator.validMobile(context, errorText: 'فقط شماره موبایل معتبر است'), // اختیاری
    //     // PhoneValidator.validFixedLine(errorText: 'فقط شماره ثابت معتبر است'), // اختیاری
    //   ]),
    //   onChanged: (final p0) => controller.text = p0.international,
    //   style: context.textTheme.bodyMedium!.copyWith(fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2),
    //   onEditingComplete: onEditingComplete,
    //   inputFormatters: [
    //     // FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
    //   ],
    // );
    return UTextFormField(
      enabled: enabled,
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      labelText: labelText ?? s.phoneNumber,
      hintText: hintText,
      required: showRequired ?? required,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.phone,
      formatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
      ],
      maxLength: maxLength,
      onEditingComplete: onEditingComplete,
      helperText: helperText,
      helperStyle: helperStyle,
      validator: (final value) {
        if (required && (value == null || value.isEmpty)) {
          return s.requiredField;
        }

        if (value != null && value.length < minLength) {
          return s.isShort.replaceAll('#', minLength.toString());
        }

        if (startWith != null && startWith!.isNotEmpty) {
          if (value != null && !value.startsWith(startWith!)) {
            return s.invalidPhoneNumber;
          }
        } else {
          // این عبارت منظم چک می‌کند که رشته با یک + اختیاری شروع شده
          // و بقیه آن فقط عدد باشد.
          final phoneRegExp = RegExp(r'^\+?[0-9]+$');

          if (value != null && value.isNotEmpty && !phoneRegExp.hasMatch(value)) {
            return "${s.invalidPhoneNumber} (${s.validBeginningSignInPhoneNumber})";
          }
        }
        return null; // یعنی معتبر است
      },
    );
  }
}
