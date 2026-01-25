---
description: Prevent modifications to utilities_flutter submodule files
globs: utilities_flutter/**
alwaysApply: false
---

# utilities_flutter Submodule Protection

پوشه `utilities_flutter/` یک **ساب ماژول Git** است و فایل‌های داخل آن نباید تغییر کنند.

## ⚠️ مهم

**هرگز فایل‌های داخل `utilities_flutter/` را تغییر ندهید.**

این پوشه یک submodule است و تغییرات باید در repository اصلی آن انجام شود.

## ✅ DO

- استفاده از فایل‌ها و کلاس‌های موجود در `utilities_flutter/`
- Import کردن از `utilities_flutter` در پروژه اصلی
- اگر نیاز به تغییر دارید، در repository اصلی submodule تغییر دهید

## ❌ DON'T

- ❌ تغییر فایل‌های داخل `utilities_flutter/`
- ❌ اضافه کردن فایل جدید به `utilities_flutter/`
- ❌ حذف فایل از `utilities_flutter/`
- ❌ تغییر dependencies در `utilities_flutter/pubspec.yaml`

## 🔧 اگر نیاز به تغییر دارید

1. به repository اصلی `utilities_flutter` بروید
2. تغییرات را در آنجا اعمال کنید
3. تغییرات را commit و push کنید
4. در این پروژه، submodule را update کنید

## 📝 مثال

```dart
// ✅ GOOD: استفاده از utilities_flutter
import 'package:utilities_flutter/utilities.dart';
import 'package:utilities_flutter/utils/extensions/string_extension.dart';

// ❌ BAD: تغییر فایل‌های داخل utilities_flutter/
// Never edit: utilities_flutter/lib/utils/string_extension.dart
```
