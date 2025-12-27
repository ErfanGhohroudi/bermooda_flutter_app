import 'package:u/utilities.dart';
import 'package:intl/intl.dart';

import '../../../core.dart';

class WAmountField extends StatefulWidget {
  const WAmountField({
    required this.controller,
    required this.labelText,
    this.currencyText,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String? currencyText;
  final bool required;
  final bool? showRequired;
  final Function(String value)? onChanged;

  @override
  State<WAmountField> createState() => _WAmountFieldState();
}

class _WAmountFieldState extends State<WAmountField> {
  @override
  Widget build(final BuildContext context) {
    final suffixStyle = context.textTheme.bodyMedium?.copyWith(color: context.theme.hintColor);
    final _currencyText = widget.currencyText != null && widget.currencyText!.isNotEmpty ? "(${widget.currencyText})" : null;

    return UTextFormField(
      initialValue: widget.controller.text,
      labelText: widget.labelText,
      hintText: "0",
      textAlign: TextAlign.left,
      required: widget.showRequired ?? widget.required,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      formatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
        ThousandsSeparatorInputFormatter(),
      ],
      onChanged: (final value) {
        widget.controller.text = value.numericOnly();
        widget.onChanged?.call(value);
      },
      suffixText: !isPersianLang ? _currencyText : null,
      prefixText: isPersianLang ? _currencyText : null,
      suffixStyle: suffixStyle,
      prefixStyle: suffixStyle,
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    // اگر متن جدید خالی است، آن را برگردان
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // ۱. عدد خالص را بدون جداکننده‌ها و با ارقام انگلیسی استخراج کن
    final String unformattedText = _getEnglishDigits(newValue.text.replaceAll(',', ''));

    // ۲. رشته را به عدد تبدیل کن. این کار به صورت خودکار صفرهای اضافی اول را حذف می‌کند.
    final int? number = int.tryParse(unformattedText);

    // اگر ورودی یک عدد معتبر نبود یا صفر بود، همان مقدار قبلی را برگردان
    if (number == null || number == 0) {
      return oldValue;
    }

    // عدد را با فرمت دلخواه دوباره به رشته تبدیل کن
    final String formattedText = _formatter.format(number);

    // --- منطق جدید و هوشمند برای محاسبه موقعیت مکان‌نما ---

    final int numDigitsBeforeCursor = _getEnglishDigits(
      newValue.text.substring(0, newValue.selection.end),
    ).replaceAll(',', '').length;

    // ۴. مکان‌نمای جدید را با پیمایش متن فرمت‌شده پیدا می‌کنیم.
    // به همان تعداد رقمی که قبل از مکان‌نما بود، در متن جدید جلو می‌رویم.
    int newCursorOffset = 0;
    int digitCount = 0;
    while (newCursorOffset < formattedText.length && digitCount < numDigitsBeforeCursor) {
      if (formattedText[newCursorOffset] != ',') {
        digitCount++;
      }
      newCursorOffset++;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: newCursorOffset,
      ),
    );
  }

  // تابع کمکی برای تبدیل ارقام فارسی/عربی به انگلیسی
  String _getEnglishDigits(final String input) {
    return input
        .replaceAll('۰', '0')
        .replaceAll('۱', '1')
        .replaceAll('۲', '2')
        .replaceAll('۳', '3')
        .replaceAll('۴', '4')
        .replaceAll('۵', '5')
        .replaceAll('۶', '6')
        .replaceAll('۷', '7')
        .replaceAll('۸', '8')
        .replaceAll('۹', '9')
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
  }
}
