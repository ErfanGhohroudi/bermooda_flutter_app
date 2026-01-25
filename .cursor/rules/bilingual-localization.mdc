---
description: استفاده از متن‌های دوزبانه (Bilingual Localization)
alwaysApply: true
---

# استفاده از متن‌های دوزبانه (Bilingual Localization)

این rule استفاده از سیستم localization دوزبانه را برای تمام متن‌های UI الزامی می‌کند.

## 📋 ساختار فایل‌های Localization

- **انگلیسی**: `lib/l10n/intl_en.arb`
- **فارسی**: `lib/l10n/intl_fa.arb`
- **کلاس تولید شده**: `lib/generated/l10n.dart` (کلاس `S`)

## ✅ DO - استفاده صحیح

### در UI (Widgets)

```dart
// ✅ GOOD: استفاده از s. برای دسترسی به متن‌ها
import 'package:bermooda_business/core/core.dart';

Widget build(BuildContext context) {
 return Text(s.invoice);
}

// ✅ GOOD: استفاده در label ها
TextFormField(
 labelText: s.customerName,
 hintText: s.search,
)

// ✅ GOOD: استفاده در دکمه‌ها
ElevatedButton(
 onPressed: () {},
 child: Text(s.save),
)

// ✅ GOOD: استفاده در پیام‌های خطا
SnackBar(
 content: Text(s.error),
)
```

### اضافه کردن کلید جدید

هنگام نیاز به متن جدید، باید در **هر دو فایل** اضافه شود:

```json
// lib/l10n/intl_en.arb
{
 "newKey": "New Text"
}

// lib/l10n/intl_fa.arb
{
 "newKey": "متن جدید"
}
```

بعد از اضافه کردن، باید فایل‌های generated را rebuild کنید.

## ❌ DON'T - استفاده نادرست

```dart
// ❌ BAD: استفاده از متن hard-coded
Text('فاکتور') // Wrong!
Text('Invoice') // Wrong!

// ❌ BAD: استفاده از متن انگلیسی یا فارسی مستقیم
Text('Save') // Wrong!
Text('ذخیره') // Wrong!

// ❌ BAD: استفاده از متغیر محلی برای متن
final String title = 'Invoice'; // Wrong!
Text(title) // Wrong!

// ❌ BAD: استفاده از S.of(context) به جای s
Text(S.of(context).invoice) // Use s.invoice instead!

// ❌ BAD: اضافه کردن کلید فقط در یک فایل
// Only in intl_en.arb - Missing!
{
 "newKey": "New Text"
}
```

## 🔑 نحوه دسترسی به متن‌ها

### در Widgets

```dart
import 'package:bermooda_business/core/core.dart';

// استفاده مستقیم از s
Text(s.invoice)
Text(s.customerName)
Text(s.save)
```

### در Controllers

```dart
import 'package:bermooda_business/core/core.dart';

class MyController extends GetxController {
 void showError() {
 Get.snackbar(s.error, s.tryAgain);
 }
}
```

## 📝 مثال‌های واقعی

### استفاده در Form Fields

```dart
// ✅ GOOD
TextFormField(
 labelText: s.firstName,
 hintText: s.enterFirstName,
 validator: (value) {
 if (value == null || value.isEmpty) {
 return s.requiredField;
 }
 return null;
 },
)
```

### استفاده در Dialogs

```dart
// ✅ GOOD
showDialog(
 context: context,
 builder: (context) => AlertDialog(
 title: Text(s.confirm),
 content: Text(s.areYouSureYouWantToDeleteItem),
 actions: [
 TextButton(
 onPressed: () => Navigator.pop(context),
 child: Text(s.cancel),
 ),
 TextButton(
 onPressed: () {
 // Delete logic
 Navigator.pop(context);
 },
 child: Text(s.delete),
 ),
 ],
 ),
);
```

### استفاده در AppBar

```dart
// ✅ GOOD
AppBar(
 title: Text(s.invoices),
 actions: [
 IconButton(
 icon: Icon(Icons.add),
 onPressed: () {},
 tooltip: s.newInvoice,
 ),
 ],
)
```

## ⚠️ نکات مهم

1. **همیشه از `s.` استفاده کن**: هرگز متن را مستقیماً در کد ننویس
2. **هر دو فایل را آپدیت کن**: هنگام اضافه کردن کلید جدید، حتماً در `intl_en.arb` و `intl_fa.arb` اضافه کن
3. **Rebuild بعد از تغییر**: بعد از تغییر فایل‌های `.arb`، فایل‌های generated را rebuild کن
4. **استفاده از کلیدهای موجود**: قبل از اضافه کردن کلید جدید، بررسی کن که آیا کلید مشابهی وجود دارد یا نه
5. **نام‌گذاری کلیدها**: از نام‌های واضح و توصیفی استفاده کن (مثلاً `invoiceDetails` نه `invDet`)

## 🔍 Checklist

قبل از commit کردن تغییرات:

- [ ] تمام متن‌های hard-coded را با `s.` جایگزین کردم؟
- [ ] کلید جدید را در هر دو فایل `intl_en.arb` و `intl_fa.arb` اضافه کردم؟
- [ ] فایل‌های generated را rebuild کردم؟
- [ ] متن‌های اضافه شده در هر دو زبان صحیح هستند؟
