---
description: Use shared custom widgets and utilities from core and utilities_flutter directories
alwaysApply: true
---

# استفاده از ویجت‌ها و یوتیلیتی‌های مشترک

این rule استفاده از ویجت‌ها و یوتیلیتی‌های مشترک موجود در پروژه را الزامی می‌کند.

## 📦 ویجت‌های مشترک (Custom Widgets)

### اولویت استفاده

هنگام نیاز به ویجت کاستوم، به ترتیب زیر عمل کن:

1. **اول**: بررسی `lib/core/widgets/` - ویجت‌های مشترک پروژه
2. **دوم**: بررسی `utilities_flutter/lib/components/` - ویجت‌های مشترک کتابخانه
3. **سوم**: اگر وجود نداشت، ویجت جدید بساز

### ✅ DO

```dart
// ✅ GOOD: استفاده از ویجت موجود از core/widgets
import 'package:bermooda_business/core/widgets/empty_widget.dart';

Widget build(BuildContext context) {
  return EmptyWidget();
}

// ✅ GOOD: استفاده از ویجت موجود از utilities_flutter
import 'package:utilities_flutter/components/form.dart';

Widget build(BuildContext context) {
  return CustomTextField(
    label: 'Name',
    onChanged: (value) {},
  );
}

// ✅ GOOD: ساخت ویجت جدید در core/widgets اگر وجود نداشت
// File: lib/core/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  // Implementation...
}
```

### ❌ DON'T

```dart
// ❌ BAD: ساخت ویجت تکراری در feature-specific directory
// File: lib/view/modules/invoice/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  // Duplicate widget that should be in core/widgets
}

// ❌ BAD: استفاده از ویجت inline به جای استفاده از ویجت مشترک
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(...),
    child: Text('Loading...'),
  );
  // Should use LoadingWidget from core/widgets instead
}
```

---

## 🛠️ یوتیلیتی‌های مشترک (Shared Utils)

### اولویت استفاده

هنگام نیاز به utility function، به ترتیب زیر عمل کن:

1. **اول**: بررسی `utilities_flutter/lib/utils/` - یوتیلیتی‌های مشترک کتابخانه
2. **دوم**: بررسی `lib/core/utils/` - یوتیلیتی‌های مشترک پروژه
3. **سوم**: اگر وجود نداشت، utility جدید بساز

### ✅ DO

```dart
// ✅ GOOD: استفاده از extension موجود از utilities_flutter
import 'package:utilities_flutter/utils/extensions/string_extension.dart';

String formatPhone(String phone) {
  return phone.toPersianNumber(); // از utilities_flutter
}

// ✅ GOOD: استفاده از utility موجود از core/utils
import 'package:bermooda_business/core/utils/extensions/date_extensions.dart';

String formatDate(DateTime date) {
  return date.toPersianDate(); // از core/utils
}

// ✅ GOOD: ساخت utility جدید در core/utils اگر وجود نداشت
// File: lib/core/utils/extensions/custom_extension.dart
extension CustomExtension on String {
  String customFormat() {
    // Implementation...
  }
}
```

### ❌ DON'T

```dart
// ❌ BAD: تکرار logic که در utilities موجود است
String formatPhone(String phone) {
  // Duplicate logic that exists in utilities_flutter
  return phone.replaceAll('0', '۰');
}

// ❌ BAD: ساخت utility در feature-specific directory
// File: lib/view/modules/invoice/utils/formatter.dart
class Formatter {
  static String format(String value) { /* ... */ }
}
// Should be in core/utils instead
```

---

## 📋 Checklist

قبل از ساخت ویجت یا utility جدید:

- [ ] بررسی کردم که در `lib/core/widgets/` وجود ندارد؟
- [ ] بررسی کردم که در `utilities_flutter/lib/components/` وجود ندارد؟
- [ ] بررسی کردم که در `utilities_flutter/lib/utils/` وجود ندارد؟
- [ ] بررسی کردم که در `lib/core/utils/` وجود ندارد؟
- [ ] اگر وجود نداشت، در مکان مناسب (`core/widgets` یا `core/utils`) ساخته‌ام؟

---

## 🎯 مثال‌های واقعی

### استفاده از ویجت موجود

```dart
// ✅ استفاده از EmptyWidget موجود
import 'package:bermooda_business/core/widgets/empty_widget.dart';

class InvoiceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return EmptyWidget(message: 'No invoices found');
    }
    // ...
  }
}
```

### استفاده از Extension موجود

```dart
// ✅ استفاده از extension موجود از utilities_flutter
import 'package:utilities_flutter/utils/extensions/string_extension.dart';

class PhoneField extends StatelessWidget {
  void formatPhone(String value) {
    final formatted = value.toPersianNumber(); // از utilities_flutter
  }
}
```

### ساخت ویجت جدید در مکان مناسب

```dart
// ✅ ساخت ویجت مشترک در core/widgets
// File: lib/core/widgets/custom_card.dart
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  
  const CustomCard({
    required this.child,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
```

---

## ⚠️ نکات مهم

1. **اولویت با utilities_flutter**: برای یوتیلیتی‌ها، اول `utilities_flutter` را بررسی کن چون کتابخانه مشترک است
2. **اولویت با core/widgets**: برای ویجت‌ها، اول `core/widgets` را بررسی کن چون پروژه-خاص است
3. **قبل از ساخت جدید**: همیشه ابتدا جستجو کن که آیا قبلاً ساخته شده یا نه
4. **مکان مناسب**: ویجت‌ها و utilityهای جدید باید در `core/` باشند نه در feature-specific directories
