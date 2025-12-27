part of 'fields.dart';

class WShebaNumberField extends StatefulWidget {
  const WShebaNumberField({
    required this.controller,
    this.enabled = true,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool required;
  final bool? showRequired;

  @override
  State<WShebaNumberField> createState() => _WShebaNumberFieldState();
}

class _WShebaNumberFieldState extends State<WShebaNumberField> {
  final FocusNode focusNode = FocusNode();
  bool isFocus = false;

  @override
  void initState() {
    focusNode.addListener(
      () {
        if (!mounted) return;
        if (focusNode.hasFocus) {
          setState(() {
            isFocus = true;
          });
        } else {
          setState(() {
            isFocus = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      controller: widget.controller,
      labelText: s.iban,
      enabled: widget.enabled,
      required: widget.showRequired ?? widget.required,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.number,
      formatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 34 - 2,
      suffix: isPersianLang && (isFocus || widget.controller.text != '') ? _ibanText() : null,
      prefix: !isPersianLang && (isFocus || widget.controller.text != '') ? _ibanText() : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (final value) => validateIban(value, required: widget.required),
    );
  }

  Widget _ibanText() {
    return const Text(
      "IR",
      textDirection: TextDirection.ltr,
    ).titleMedium();
  }

  String? validateIban(String? value, {final bool required = false}) {
    // 1. بررسی ورودی اولیه
    if (required && (value == null || value.isEmpty)) {
      return s.requiredField;
    }

    if (value == null || value.isEmpty) return null;

    if (value.isNotEmpty) {
      value = "IR$value";
    }

    // 2. آماده‌سازی رشته: حذف فاصله‌ها و تبدیل به حروف بزرگ
    final String iban = value.replaceAll(' ', '').toUpperCase();

    // 3. بررسی حداقل طول (کوتاه‌ترین IBAN مربوط به نروژ با ۱۵ کاراکتر است)
    if (iban.length < 15) {
      return s.isShort.replaceAll("#", "15");
    }

    // بررسی طول مشخص برای شبا ایران (اختیاری ولی توصیه می‌شود)
    if (iban.startsWith('IR') && iban.length != 26) {
      return s.iranIBANisShort;
    }

    // 4. جابجایی ۴ کاراکتر اول به انتهای رشته
    final String rearrangedIban = iban.substring(4) + iban.substring(0, 4);

    // 5. تبدیل حروف به عدد (A=10, B=11, ..., Z=35)
    final String numericIban = rearrangedIban.split('').map((final char) {
      // اگر کاراکتر حرف بود، مقدار عددی آن را برمی‌گردانیم
      if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
        // A-Z
        return (char.codeUnitAt(0) - 55).toString();
      }
      // در غیر این صورت خود عدد را برمی‌گردانیم
      return char;
    }).join('');

    // 6. محاسبه باقی‌مانده تقسیم بر ۹۷
    // چون عدد حاصل بسیار بزرگ است، باید از BigInt استفاده کنیم
    try {
      final BigInt ibanAsInt = BigInt.parse(numericIban);
      if (ibanAsInt.modInverse(BigInt.from(97)) == BigInt.from(1)) {
        return null; // یعنی معتبر است
      } else {
        return s.invalidIBAN;
      }
    } catch (e) {
      return s.invalidIBANFormat;
    }
  }
}
